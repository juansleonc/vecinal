class Reservation < ApplicationRecord
  enum status: {
    pending: 'pending',
    pre_approved: 'pre-approved',
    approved: 'approved',
    cancelled: 'cancelled'
  }

  validates :amenity_id, :date, :time_from, :time_to, presence: true
end
