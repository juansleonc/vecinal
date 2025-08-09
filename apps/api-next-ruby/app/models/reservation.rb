class Reservation < ApplicationRecord
  enum status: {
    pending: 'pending',
    pre_approved: 'pre-approved',
    approved: 'approved',
    cancelled: 'cancelled'
  }

  validates :amenity_id, :date, :time_from, :time_to, presence: true
  validates :status, inclusion: { in: statuses.values }
  validates :time_from, format: { with: /\A[0-2][0-9]:[0-5][0-9]\z/ }
  validates :time_to, format: { with: /\A[0-2][0-9]:[0-5][0-9]\z/ }
end
