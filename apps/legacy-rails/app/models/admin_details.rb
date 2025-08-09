# This model is actually not used, we conserve it for posible issues with migrations

class AdminDetails < ActiveRecord::Base

  belongs_to :user

  # validates :title_position, presence: true
  # validates :phone, presence: true

end
