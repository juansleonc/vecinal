class ServiceRequest < ActiveRecord::Base
  PER_PAGE = 20

  include Markable
  include Attachmentable
  include Unreadable
  include Countable

  CATEGORIES = %w[general repairs complaints fees rent lease reservations other]
  STATUSES = %w[pending in_progress resolved closed]
  REPORT_TYPE = %w[30 60 90 180 365]

  belongs_to :user
  alias publisher user
  
  belongs_to :responsible, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  
  
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true, if: "attachments.size == 0"
  validates :category, inclusion: { in: CATEGORIES, allow_blank: false }
  validates :status, inclusion: { in: STATUSES, allow_blank: false }

  before_validation :set_status
  before_save :set_responsible
  after_create :notify_receivers

  scope :open, -> { where status: %w[pending in_progress resolved] }
  scope :closed, -> { where status: 'closed' }

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
      raw_sql += " service_requests.id = #{part.to_i} OR service_requests.title ILIKE '%#{part}%' OR service_requests.content ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' OR contact_details.apartment_numbers ILIKE '%#{part}%' "
      unless list_id.join(',').empty?
        raw_sql += " OR users.id in (#{list_id.join(',')}) "
      end
    end
    #''
    distinct.joins(user: :contact_details).where(raw_sql)
  }

  scope :open_count, -> (requests) { where(status: 'open', id:requests.ids).count }
  scope :closed_count, -> (requests) { where(status: 'closed', id:requests.ids).count }
  scope :beetwen, -> (date1, date2, users, status) { where('created_at >= ? and created_at <= ? and status = ?', date1, date2, status).by(users) }
  scope :my_responsability, -> (responsible_id) { where(responsible_id: responsible_id)}
  scope :is_board_member, -> (user_id) { where(user_id: user_id)}
    
  def self.open_count start, final, users
    beetwen(final, final, users, 'open').count
  end

  def self.closed_count start, final, users
    beetwen(final, final, users, 'closed').count
  end

  def self.search_in_ticket(query)
    search_by(query)
  end

  def self.to_csv
    attributes = %w{id created_at user_id role apartment_numbers community email phone title content category responsible_id urgent  status  updated_at reviews last-comment rate_score}
    attributes2 = %w{ticket created_at user role apartment_numbers community email phone title content category assigned-to urgent  status  updated_at reviews last-comment rate-score}
    CSV.generate(headers: true) do |csv|
      csv << attributes2
      all.each do |request|
        csv << attributes.map{ |attr| 
          if attr == 'user_id'
            request.user.full_name
          elsif attr == 'responsible_id'
            unless request.responsible.class.name == 'Company'
              request.responsible.full_name
            else
              ''
            end
          elsif attr == 'role'
            request.user.role
          elsif 'apartment_numbers' == attr && request.user.contact_details&.send(attr).present?
            request.user.contact_details&.send(attr).to_s
          elsif attr == 'community' 
            request.user.accountable.send('name')
          elsif attr == 'email'
            request.user.send('email')
          elsif attr == 'phone'
            request.user.contact_details&.send(attr).to_s
          elsif attr == 'reviews' 
            request.comments.count > 0 ? 'yes' : 'no'
          elsif attr == 'last-comment'
            if request.comments.count > 0
              request.comments.last.content
            else
              ''
            end
          else            
            request[attr]
          end
        }     
      end
    end
  end

  def self.with_user(user)
    if user.admin? || user.collaborator?
      where 'service_requests.user_id = ? OR (responsible_type = ? AND responsible_id IN (?)) OR (responsible_type = ? AND responsible_id = ?)',
        user.id, "User", (user.contacts + [user]), user.accountable_type, user.accountable_id
    elsif user.resident?
      where user: user
    else
      self.none
    end
  end
  
  def set_status
    self.status = STATUSES.first if self.status.blank?
  end

  def set_responsible
    if self.responsible.blank?
      self.responsible = User.find (user.accountable_type == 'Company' ? user.accountable.user_id : user.accountable.get_admin_default_requests)
    end
  end

  

  def classy_id
    "%04d" % id
  end

  def category_translation
    I18n.t("general.service_request_categories.#{category}")
  end

  def status_translation
    I18n.t("general.service_request_statuses.#{status}")
  end

  def responsible_name
    self.responsible_type == 'Company' ? self.responsible.name : self.responsible.full_name
  end

  def responsible_user_id
    responsible_id if responsible_type == 'User'
  end

  def attachment_col_size
    'col-xs-3'
  end

  def closed?
    self.status == 'closed'
  end

private

  def notify_receivers
    receivers = [responsible]
    receivers += [user] unless receivers.include?(user)
    receivers.each do |receiver|
      UserMailer.new_service_request(self, receiver).deliver_later if receiver.setting_for('email_when_new_service_request') == 'yes'
    end
  end

end
