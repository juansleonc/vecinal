class Share < ActiveRecord::Base
  belongs_to :shareable, polymorphic: true
  belongs_to :recipientable, polymorphic: true

  validates :shareable, presence: true
  validates :recipientable, presence: true
end
