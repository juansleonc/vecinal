class Marker < ActiveRecord::Base

  LIMIT_REPORTED = 3

  belongs_to :user
  belongs_to :markable, polymorphic: true

  validates :user, uniqueness: { scope: [:markable_type, :markable_id] }

  after_create :trigger_mark_actions

  scope :reported, -> { where label: "reported" }

private

  def trigger_mark_actions
    if %w[Comment Review Classified Poll].include?(markable_type) && markable.marks_count('reported') > LIMIT_REPORTED
      markable.destroy
    end
  end

end
