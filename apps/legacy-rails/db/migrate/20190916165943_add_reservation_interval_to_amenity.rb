class AddReservationIntervalToAmenity < ActiveRecord::Migration
  def change
    add_column :amenities, :reservation_interval, :float, :default => 1
  end
end
