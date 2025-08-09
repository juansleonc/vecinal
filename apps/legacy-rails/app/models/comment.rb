class Comment < ActiveRecord::Base

  include Markable
  include Attachmentable
  include Unreadable
  include Shareable
  include Countable

  BUILDING_PER_PAGE = 20
  BUSINESS_PER_PAGE = 20
  USER_PER_PAGE = 20
  COMPANY_PER_PAGE = 20

  belongs_to :user
  belongs_to :publisher, class_name: 'User', foreign_key: :user_id
  belongs_to :commentable, polymorphic: true, touch: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true, if: "attachments.size == 0"
  # validates :commentable_type, presence: true
  validates :commentable_id, presence: true
  validates :user_id, presence: true

  after_create :fire_events, :notify_user
  after_save :mark_as_personal, if: :cannot_user_post_for_community?

  scope :search_by, -> (query) {
    query_parts = query.split(' ')
    raw_sql = ''
    $build_query = distinct.joins(:user)
    .joins('LEFT OUTER JOIN "contact_details" ON "contact_details"."user_id" = "users"."id"')

    query_parts.each do |part|
      result_building = Building.search_by(part)
      list_id  = []
      list_id << result_building.map{ |b| b.contacts.map{ |u| u.id } }
  
      if raw_sql != ''
        raw_sql += " OR "
      end
      raw_sql += " comments.content ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' OR contact_details.apartment_numbers ILIKE '%#{part}%' "

      unless list_id.join(',').empty?
        raw_sql += " OR comments.commentable_id in (#{list_id.join(',')}) "
      end
    end
    
    $build_query.where(raw_sql)
  }

  scope :by_shared, -> (shared) {
    where " EXISTS (SELECT shares.shareable_id  FROM shares WHERE shares.shareable_id = comments.id AND shares.recipientable_id = " + shared.id.to_s + " AND recipientable_type = '" + shared.class.name + "')"
    
  }

  scope :shared_public, -> {
    where "NOT EXISTS (SELECT shares.id FROM shares WHERE shares.shareable_id = comments.id AND shareable_type = 'Comment')"
  }

  scope :by , -> (users) { where(user: users, commentable_type: %w[Building User Company]) }
  scope :by_adaptive, -> (users, types) {where(user: users, commentable_type: types)}
  scope :beetwen, -> (date1, date2, users, types) { where('created_at >= ? and created_at <= ?', date1, date2).by_adaptive(users, types) }
  scope :marked_as_personal, -> { joins(:markers).where markers: {label: "personal"} }
  scope :not_personal, -> { where.not(id: marked_as_personal.ids) }

  def images
    attachments.to_a.keep_if(&:image?)
  end

  def files
    attachments.to_a.reject(&:image?)
  end

  def fire_events
    if %w[Message ServiceRequest Event Comment Reservation].include? commentable_type
      commentable.mark_as_replied_by(user)
    elsif %w[Company Building].include? commentable_type
      mark_as_read_for_sender
    end
  end

  def attachment_col_size
    if %w[Message ServiceRequest Reservation].include? commentable_type
      'col-xs-3'
    elsif %w[Company Building Comment Event User].include? commentable_type
      'col-xs-6'
    end
  end

  def notify_new_reply(comment)
    commentable.notify_new_reply(comment) if commentable != user
    user.notify_new_reply(comment)
  end


  def self.posts_count start, final, users
    beetwen(start, final, users, %w[Building User Company]).count
  end

  def self.comments_count start, final, users
    beetwen(start, final, users, 'Comment').count
  end

private
  def create_recipient
    if ['Building', 'Company', 'User'].include? commentable_type
      super
    end
  end

  def notify_user
    list_user = []
    if %w[User Company Building].include?(commentable_type)
      commentable.notify_new_post(self)
    elsif commentable_type == 'Comment'
      commentable.notify_new_reply(self)
    elsif  commentable_type == 'ServiceRequest'
      commentable.publisher.notify_new_reply(self)
      commentable.responsible.notify_new_reply(self)
      list_user << commentable.publisher
      list_user << commentable.responsible
      commentable.comments.map { |comment| 
        unless list_user.include? comment.user
          comment.user.notify_new_reply(self)
          list_user << comment.user 
        end
      }      
      
    else
      commentable.publisher.notify_new_reply(self)
    end
  end

  def cannot_user_post_for_community?
    !user.can_do_by_setting? "who_can_post_timeline"
  end

  def mark_as_personal
    mark! self.user, "personal"
  end

end
