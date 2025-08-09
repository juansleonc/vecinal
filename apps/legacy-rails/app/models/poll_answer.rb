class PollAnswer < ActiveRecord::Base
  belongs_to :poll
  has_many :poll_votes, dependent: :destroy

  validates :poll, presence: true, on: :update
  validates :name, presence: true

  def percentage_votes
    return 0 if poll.poll_votes.count == 0
    (poll_votes.count.to_f/poll.poll_votes.count.to_f * 100).round
  end


end
