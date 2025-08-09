class PollVote < ActiveRecord::Base

  include Countable

  belongs_to :user
  belongs_to :poll
  belongs_to :poll_answer

  validates :poll, presence: true, uniqueness: { scope: :user }
  validates :poll_answer, presence: true

  scope :filtered_by_poll, -> (poll) { where poll: poll }

end
