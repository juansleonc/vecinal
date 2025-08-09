class Reservation < ActiveRecord::Base

  include Unreadable
  include Countable

  STATUSES = %w[pending pre-approved approved cancelled]
  PAYMENTS = %w[paid N/A pending]
  PER_PAGE = 20

  belongs_to :amenity
  belongs_to :reserver, class_name: 'User'
  alias publisher reserver

  alias_attribute :user, :reserver

  belongs_to :user, class_name: 'User', foreign_key: 'reserver_id'
  belongs_to :responsible, class_name: 'User', foreign_key: 'responsible_id'

  has_many :comments, as: :commentable, dependent: :destroy

  validates :reserver, presence: true
  validates :amenity, presence: true
  validates :date, presence: true
  validates :time_from, presence: true
  validates :time_to, presence: true
  validates :status, inclusion: { in: STATUSES }
  # validates :payment, inclusion: { in: PAYMENTS }, on: :update #commented for payments implementation
  validates :message, presence: true

  before_validation :set_defaults, on: :create
  before_validation :check_reservation_length, on: :create
  before_validation :check_max_reservations_per_user, on: :create
  before_validation :working_hours, on: :create

  before_validation :check_auto_approve, on: :create
  before_save :validate_availability
  before_create :set_responsible
  after_create :notify_users

  scope :collides_with, ->(r) {
    where 'amenity_id = :amenity AND date = :date AND status = :status AND (
        (time_from BETWEEN :tf AND :tt) OR (time_to BETWEEN :tf AND :tt) OR (time_from < :tf AND time_to > :tt)
      )',
    { amenity: r.amenity, date: r.date, status: 'approved', tf: r.time_from, tt: r.time_to }
  }

  scope :search_by, -> (query) { 
    raw_sql = ''
    query_parts = query.split(' ')
    query_parts.each do |part|
      result_building = Building.search_by(part)
      list_id  = []
      list_id << result_building.map{ |b| b.id }
      if raw_sql != ''
        raw_sql += " OR "
      end
      raw_sql += " reservations.status ILIKE '%#{part}%' OR reservations.message ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' OR amenities.name ILIKE '%#{part}%' OR buildings.name ILIKE '%#{part}%' OR contact_details.apartment_numbers ILIKE '%#{part}%' "
      
      unless list_id.join(',').empty?
        raw_sql += " OR reserver_id in (#{list_id.join(',')}) "
      end
    end
    #''
    distinct.joins(reserver: :contact_details, amenity: :building ).where(raw_sql)
  }

  def mark_as_read_for_sender
    mark_as_read! for: reserver
  end

private

  def set_defaults
    reserver = Reservation.new()
    self.status ||= 'pending'
  end

  def validate_availability
    unless available?
      errors.add :amenity, :not_available
      false
    end
  end

  def available?
    return true if reserver.role == 'administrator'
    return true if amenity.availability_type == 'allways_open'
    return false if amenity.availability_type == 'no_available'
    return false if (date + time_from.seconds_since_midnight.seconds) < Time.zone.now
    return false if time_from > time_to
    availability = amenity.availabilities.active.find_by_day date.wday
    return false if availability.blank?
    return false if time_from < availability.time_from || time_to > availability.time_to
    return false if amenity.maximun_rental_time? && (time_to - time_from) > (amenity.maximun_rental_time * 3600)
    return false if Reservation.collides_with(self).present?
    true
  end

  def notify_users
    users = [set_responsible]
    users += [reserver] unless users.include?(reserver)
    users.each do |user|
      UserMailer.new_reservation(self, user).deliver_later if user.setting_for('email_when_new_reservation') == 'yes'
    end
  end

  def set_responsible
    self.responsible = User.find (amenity.building.admin_default_reservations > 0 ? amenity.building.admin_default_reservations : amenity.building.company.user_id )
  end

  def check_reservation_length 
    
    start_time = DateTime.now.change({ hour: self.time_from.hour, min: self.time_from.min, sec: self.time_from.sec })
    end_time = DateTime.now.change({ hour: self.time_to.hour, min: self.time_to.min, sec: self.time_to.sec })

    case (amenity.reservation_length_type)
    when 'days'
      max_time = start_time + amenity.reservation_length*60
    when 'hours'
      time_diff = ((end_time - start_time) * 24 * 60).to_i
      reservation_length = amenity.reservation_length
      if reservation_length == '0.5'
        reservation_length = 30
      else
        reservation_length = reservation_length * 60
      end
    end
    
    if time_diff.to_i > reservation_length.to_i
      errors.add(:base, I18n.t('amenities.errors.reservation_length', length: amenity.reservation_length.to_s, type: amenity.reservation_length_type))         
    end
    
  end

  def check_max_reservations_per_user
    
    init_date = DateTime.now.change({ year: self.date.year, month: self.date.month, day: self.date.day, hour: self.time_from.hour, min: self.time_from.min })
    
    case amenity.max_reservations_per_user_type.downcase
    when 'days'
      end_date = init_date.end_of_day
      init_date = init_date.at_beginning_of_day
    when 'week'
      end_date = init_date.at_end_of_week
      init_date = init_date.at_beginning_of_week
    when 'month'
      end_date = init_date.at_end_of_month
      init_date = init_date.at_beginning_of_month
    when 'year'
      end_date = init_date.at_end_of_year      
      init_date = init_date.at_beginning_of_year
    else
    end
    
    total_count = self.reserver.reservations.where("date BETWEEN ? and ? and reserver_id = ? and amenity_id = ? ", init_date.to_s, end_date.to_s, self.reserver_id, self.amenity_id).count
    
    if total_count >= amenity.max_reservations_per_user
      errors.add(:base, I18n.t('amenities.errors.reservations_per_user', max_reservations_per_user: amenity.max_reservations_per_user, type: amenity.max_reservations_per_user_type)) 
    end 
    
    
  end

  def working_hours
    if amenity.availability_type == 'selected_hours'
      
      amenity.availabilities
      reservation_date = DateTime.parse(self.date.to_s)
      availability = amenity.availabilities.where(day: reservation_date.strftime("%w")).first

      if availability.time_from.strftime('%H:%M') > self.time_from.strftime('%H:%M')
        errors.add(:base, I18n.t('amenities.errors.reservations_working_hours', time_from: availability.time_from.strftime('%H:%M'), time_to: availability.time_to.strftime('%H:%M'))) 
        
      end
      
      if availability.time_to.strftime('%H:%M') < self.time_to.strftime('%H:%M') || self.time_to.strftime('%H:%M') == '00:00'
        errors.add(:base, I18n.t('amenities.errors.reservations_working_hours', time_from: availability.time_from.strftime('%H:%M'), time_to: availability.time_to.strftime('%H:%M'))) 
      end
    end
  end

  def check_auto_approve
    if amenity.auto_approval
      self.status = 'approved'
    end
  end

end
