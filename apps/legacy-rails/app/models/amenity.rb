class Amenity < ActiveRecord::Base

  include HasLogo
  include Reviewable
  include Shareable
  include Countable

  AVAILABILITY_TYPES = %w[selected_hours allways_open no_available]
  
  RESERVATION_LENGTH_TYPE = %w[hours]
  MAX_RESERVATION_PER_USER_TYPE = %w[days week month year]

  INTERVAL = %w[0.5 1]
  
  DEFAULT_TIME_FROM = '6:00'
  DEFAULT_TIME_TO = '22:00'
  PER_PAGE = 20
  
  MAX_RESERVATION_LENGTH_HOURS = %w[0.5 1 2 3 4 5 6 8 12 24]
  MAX_RESERVATION_LENGTH_DAYS = %w[1 2 3 4 5 6 7]
  MAX_RESERVATION_PER_USER = %w[1 2 3 4 5]

  belongs_to :building
  has_many :images, as: :imageable, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :availabilities

  validates :building, presence: true
  validates :name, presence: true
  validates :rental_value, presence: true, numericality: { greater_than: 0, less_than: 999999999.99, allow_blank: true }, if: :rental_fee
  validates :deposit_value, presence: true, numericality: { greater_than: 0, less_than: 999999999.99, allow_blank: true }, if: :deposit
  validates :reservation_length, numericality:{ greater_than: 0 }
  validates :description, presence: true
  validates :maximun_rental_time, numericality: { only_integer: true, allow_blank: true }, on: :update
  validates :availability_type, presence: true, inclusion: { in: AVAILABILITY_TYPES }

  before_validation :set_defaults, on: :create

  after_create :create_availabilities

  before_validation :check_max_reservation_length

  scope :ordered, -> { order name: :asc }

  scope :availability, -> {
    select("id, building_id, name, description, rental_fee, rental_value, deposit, deposit_value, maximun_rental_time, availability_type, created_at, updated_at,deleted_at, logo_file_name, logo_content_type, logo_file_size, logo_updated_at, reservation_length, reservation_length_type, max_reservations_per_user, max_reservations_per_user_type , auto_approval, reservation_interval, case
    when availability_type = 'selected_hours' then 0
    when availability_type = 'allways_open' then 1
    when availability_type = 'no_available' then 2
    else 3 
    END AS status" )
      .order('status ASC')
  }

  scope :search_by, -> (query) { 
    raw_sql = ''
    query_parts = query.split(' ')
    query_parts.each do |part|
      result_building = Building.search_by(part)
      list_id  = []
      list_id << result_building.map{ |b| b.contacts.map{ |u| u.id } }
      if raw_sql != ''
        raw_sql += " OR "
      end
      raw_sql += " amenities.name ILIKE '%#{part}%' OR amenities.description ILIKE '%#{part}%' "
      unless list_id.join(',').empty?
        raw_sql += " OR building_id in (#{list_id.join(',')}) "
      end
    end
    distinct.where(raw_sql)
  }

  scope :beetwen, -> (date1, date2) { where('amenities.created_at >= ? and amenities.created_at <= ?', date1, date2) }
  
  def self.amenities_count start, final, users, community
    community ||= current_user.my_company
    community.amenities.beetwen(start, final).count
  end

  def self.reservations_count start, final, users
    Reservation.presents_beetwen(start, final, users).count
  end

  def home_image
    self.images.where(home: true).first || ImageAmenity.new
  end

  def max_time
    maximun_rental_time? ? "(#{I18n.t 'amenities.max_time', hours: maximun_rental_time })" : ''
  end

  def availability_hours
    return I18n.t("amenities.availability_types.#{availability_type}") unless availability_type == 'selected_hours'
    availability = availabilities.active.ordered.first
    availability.time_from.strftime('%k:%M') + ' - ' + availability.time_to.strftime('%k:%M')
  end

  def notify_new_review(review)
  end

  def first_name_letter
    self.home_image.image.url != 'condomedia_cover_original.jpg' ? '' : name.to_s.chr
  end

  def mylogo
    self.home_image.image.url != 'condomedia_cover_original.jpg' ? self.home_image.image : self.logo
  end
protected
  def check_max_reservation_length
    if self.reservation_length_type == 'days' 
      if self.reservation_length < 1
        self.reservation_length = 1 
      end
    end
  end
private

  def create_availabilities
    (0..6).each do |i|
      availabilities.create day: i, time_from: DEFAULT_TIME_FROM, time_to: DEFAULT_TIME_TO, active: true
    end
  end

  def set_defaults
    self.availability_type = 'allways_open'
    self.reservation_length_type = 'hours'
    self.max_reservations_per_user_type = 'days'
  end

end
