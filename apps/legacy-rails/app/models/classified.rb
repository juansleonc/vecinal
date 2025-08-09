class Classified < ActiveRecord::Base

  include Attachmentable
  include Shareable
  include Markable

  PER_PAGE = 50
  DISTANCE_FOR_PUBLICS = 50

  belongs_to :publisher, class_name: 'User'
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :publisher, presence: true

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
      raw_sql += " classifieds.title ILIKE '%#{part}%' OR classifieds.description ILIKE '%#{part}%' OR users.first_name ILIKE '%#{part}%' OR users.last_name ILIKE '%#{part}%' "
      
      unless list_id.join(',').empty?
        raw_sql += " OR publisher_id in (#{list_id.join(',')}) "
      end
    end
    distinct.joins(:publisher).where(raw_sql)
  }

  scope :shared_public, -> {
    where "NOT EXISTS (SELECT shares.id FROM shares WHERE shares.shareable_id = classifieds.id AND shareable_type = 'Classified')"
  }

  after_create :notify_users

private

  def notify_users
    recipient.contacts.each do |user|
      UserMailer.new_classified(self, user).deliver_later if user.setting_for('email_when_new_classified') == 'yes'
    end
  end

end
