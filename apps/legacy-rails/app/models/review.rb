class Review < ActiveRecord::Base

  include Attachmentable
  include Markable
  include Shareable

  MAX_RANK = 5
  MIN_RANK = 1

  belongs_to :reviewable, polymorphic: true
  belongs_to :user
  belongs_to :publisher, class_name: 'User', foreign_key: :user_id

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :reviewable, presence: true
  validates :user, presence: true
  validates :rank, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: MIN_RANK,
    less_than_or_equal_to: MAX_RANK, allow_blank: true
  }

  after_create :notify_reviewable

private

  def notify_reviewable
    reviewable.notify_new_review self
  end

end
