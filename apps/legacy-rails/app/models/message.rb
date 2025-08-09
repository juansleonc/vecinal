class Message < ActiveRecord::Base

  PER_PAGE = 20

  include Markable
  include Receiverable
  include Attachmentable
  include Unreadable
  include Countable

  has_many :messages_users, class_name: 'MessagesUsers', dependent: :destroy
  has_many :users, through: :messages_users

  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true, if: 'attachments.size == 0'

  after_save :notify_receivers

  scope :with_user, lambda{ |user| joins(:users).where(['messages.sender_id = ? OR users.id = ?', user.id, user.id]).distinct }

  scope :not_destroyed_for, (lambda do |user|
    where.not(
      id: Marker.where(
        markable_type: "Message",
        user_id: user.id,
      ).where( "(created_at < ? AND label = ?) OR (label = ?)", Time.now - 10.days, 'deleted', 'destroyed').pluck(:markable_id)
    )
  end)

  scope :marked, lambda { |user, *labels| joins(:markers).where(markers: { user_id: user, label: labels.flatten } ) }

  scope :not_marked_as, -> (*labels) { where.not id: Message.joins(:markers).where(markers: {label: labels.flatten}) }

  scope :unread, -> (user) { where.not id: Message.marked(user, %w[deleted destroyed done email_read]) }

  scope :inbox_for, -> (user) { where.not id: Message.marked(user, %w[deleted destroyed done]) }

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
      raw_sql += " messages.title ILIKE '%#{part}%' OR messages.content ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' OR contact_details.apartment_numbers ILIKE '%#{part}%' "
      unless list_id.join(',').empty?
        raw_sql += " OR users.id in (#{list_id.join(',')}) "
      end
    end
    #''
    distinct.joins(users: :contact_details).where(raw_sql)
  }

  def notify_receivers    
    receivers = users - [sender]
    receivers.each do |receiver|
      UserMailer.new_message(self, receiver).deliver_now if receiver.setting_for('email_when_message') == 'yes' || sender.admin?
    end
  end

  def mark_as_read_for_sender
    mark_as_read! for: sender
    mark! sender, 'email_read'
  end

  def self.folder_name(folder)
    folder ? I18n.t("messages.filters.#{folder}", default: I18n.t('messages.filters.inbox')) : I18n.t('messages.filters.inbox')
  end

  def self.folder_cleaner(folder)
    %w[done deleted].include?(folder) ? folder : 'all'
  end

  def sent_same_day?
    (self.created_at + 1.day) > Time.zone.now
  end

  # def new_email_body(sender, receiver)
  #   if sender == receiver
  #     names = (self.users - [sender]).map{ |u| u.full_name }.join(', ')
  #     return I18n.t 'mailer.new_message.body_sender', names: names
  #   end
  #   accountable_details = if receiver.accountable_type == 'Company' && sender.contact_details
  #     "#{sender.accountable.name} #{I18n.t('contacts.unit')} #{sender.contact_details.apartment_number}"
  #   else
  #     sender.accountable.name
  #   end
  #   I18n.t('mailer.new_message.body', name: sender.full_name, accountable_details: accountable_details)
  # end

  def attachment_col_size
    'col-xs-3'
  end

  def self.messages_count start, final, users
    presents_beetwen(start, final, users).count
  end

  def self.replies_count start, final, users
    Comment.beetwen(start, final, users, 'Message').count
  end

end
