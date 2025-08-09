class Availability < ActiveRecord::Base

  belongs_to :amenity

  validates :day, inclusion: { in: (0..7) }
  validates :time_from, presence: true
  validates :time_to, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :amenity, presence: true

  scope :active, -> { where active: true }
  scope :ordered, -> { order day: :asc }

  
  

end
