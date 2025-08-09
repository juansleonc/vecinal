class Event < ActiveRecord::Base

  include Markable
  include Receiverable
  include Attachmentable
  include Unreadable
  include Shareable
  include Countable

  PER_PAGE = 20

  has_many :events_users, class_name: 'EventsUsers', dependent: :destroy
  has_many :users, through: :events_users
  has_many :images, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :title, presence: true
  validates :date, presence: true
  validates :time_from, presence: true
  validates :time_to, presence: true

  after_save :notify_receivers

  scope :with_user, lambda { |user| where(id: EventsUsers.where(user_id: user.id).pluck(:event_id)) }

  scope :by_month, -> (date_in) {
    where('date >= ? AND date <= ?', date_in.beginning_of_month, date_in.end_of_month).order(date: :asc)
  }

  scope :upcoming_and_past, -> {
    where('date >= ? AND date <= ?', Time.zone.now.beginning_of_day, Time.zone.now + 1.month).order(date: :asc) +
    where('date >= ? AND date < ?', Time.zone.now - 6.months, Time.zone.now.beginning_of_day).order(date: :desc)
  }

  scope :upcoming, -> { where 'date >= ?', Time.zone.now.beginning_of_day }

  scope :past, -> { where 'date < ?', Time.zone.now.beginning_of_day }

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
      raw_sql += " events.title ILIKE '%#{part}%' OR events.details ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' "
      unless list_id.join(',').empty?
        raw_sql += " OR users.id in (#{list_id.join(',')}) "
      end
    end
    #''
    distinct.joins(:users).where(raw_sql)
  }

  # def update_events_users
  #   events_users.where.not(user_id: user_receivers.pluck(:id)).delete_all
  #   user_receivers.where.not(id: events_users.pluck(:user_id)).each do |user|
  #     EventsUsers.create(event_id: self.id, user_id: user.id)
  #   end
  # end

  def mark_as_read_for_sender
    mark_as_read! for: sender
  end

  def self.in_calendar(date_in, user)
    events_in_calendar = Event.with_user(user).by_month(date_in)
    events_modal = events_in_calendar.dup
    events = Event.with_user(user).unexpired(date_in)
    events.each do |event|
      event_dup = event.dup
      event_dup.dup_id = event.id
      event_dup.increment_by_frequency
      while event_dup.date <= event_dup.expires_at && event_dup.date <= date_in.end_of_month
        if event_dup.date >= date_in.beginning_of_month
          events_modal << event unless events_modal.include? event
          events_in_calendar << event_dup.dup
        end
        event_dup.increment_by_frequency
      end
    end
    {calendar: events_in_calendar, modals: events_modal}
  end

  def upcoming?
    self.date >= Time.zone.now.beginning_of_day
  end

  def new_email_body(sender, receiver)
    if sender == receiver
      names = (self.users - [sender]).map{ |u| u.full_name }.join(', ')
      return I18n.t 'mailer.new_event.body_sender', names: names
    end
    accountable_details = if receiver.accountable_type == 'Company' && sender.contact_details
      "#{sender.accountable.name} #{I18n.t('contacts.unit')} #{sender.contact_details.apartment_numbers_joined}"
    else
      sender.accountable.name
    end
    I18n.t('mailer.new_event.body', name: sender.full_name, accountable_details: accountable_details)
  end

  def self.past_count start, final, users
    past.presents_beetwen(start, final, users).count
  end

  def self.upcoming_count start, final, users
    upcoming.presents_beetwen(start, final, users).count
  end
    
  private

    def notify_receivers
      users.each do |receiver|
        UserMailer.new_event(self, receiver).deliver_later if receiver.setting_for('email_when_new_event') == 'yes'
      end
    end

end


