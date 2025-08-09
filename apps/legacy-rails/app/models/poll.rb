class Poll < ActiveRecord::Base

  include Attachmentable
  include Shareable
  include Unreadable
  include Markable
  include Countable

  LIMIT_TYPE = %w[days date]
  MIN_NUMBER_ANSWERS = 1
  MAX_NUMBER_ANSWERS = 10
  PER_PAGE = 20
  DISTANCE_FOR_PUBLICS = 20

  belongs_to :publisher, class_name: 'User'
  alias_attribute :user, :publisher
  # belongs_to :building
  has_many :poll_answers, dependent: :destroy
  has_many :poll_votes, dependent: :destroy

  validates :publisher, presence: true
  # validates :building, presence: true
  validates :question, presence: true
  validates :end_date, presence: true
  validates :days_or_date, presence: true, inclusion: { in: LIMIT_TYPE }, on: :create
  validates :duration, presence: true, numericality: { only_integer: true, allow_blank: true, less_than: 366 }, if: "days_or_date == 'days'", on: :create
  validates :end_date_date, presence: true, if: "days_or_date == 'date'", on: :create
  validates :poll_answers, length: { minimum: MIN_NUMBER_ANSWERS, maximum: MAX_NUMBER_ANSWERS,
    message: I18n.t('polls.min_max', min: MIN_NUMBER_ANSWERS, max: MAX_NUMBER_ANSWERS)
  }
  validate :end_date_on_future

  attr_accessor :duration, :end_date_date, :days_or_date

  before_validation :set_end_date, on: :create

  accepts_nested_attributes_for :poll_answers, allow_destroy: true

  scope :most_recent, -> { order updated_at: :desc }

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
      raw_sql += " polls.question ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' OR poll_answers.name ILIKE '%#{part}%' OR contact_details.apartment_numbers ILIKE '%#{part}%' "
      unless list_id.join(',').empty?
        raw_sql += " OR building_id in (#{list_id.join(',')}) "
      end
    end
    #''
    distinct.joins(:poll_answers, publisher: :contact_details).where(raw_sql)
  }

  scope :shared_public, -> {
    where "NOT EXISTS (SELECT shares.id FROM shares WHERE shares.shareable_id = polls.id AND shareable_type = 'Poll')"
  }

  after_create :notify_users

  def closed?
    Time.zone.now >= end_date
  end

  def mark_as_read_for_sender
    mark_as_read! for: publisher
  end

  def self.polls_count start, final, users
    presents_beetwen(start, final, users).count
  end

  def self.votes_count start, final, users
    PollVote.presents_beetwen(start, final, users).count
  end

private

  def set_end_date
    self.end_date = if days_or_date == 'days' && duration.present?
      Time.zone.now + duration.to_i.days
    elsif days_or_date == 'date' && end_date_date.present?
      end_date_date
    end
    self.end_date = end_date.at_end_of_day if end_date
  end

  def end_date_on_future
    if end_date.present? && end_date < Time.zone.now
      errors.add :end_date, :be_in_future
      return false
    end
  end

  def notify_users
    recipient.contacts.each do |user|
      UserMailer.new_poll(self, user).deliver_later if user.setting_for('email_when_new_poll') == 'yes'
    end
  end

end
