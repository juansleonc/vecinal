class AddReservationLengthAndMaximumReservationsPerUserToAmenities < ActiveRecord::Migration
  def change
    add_column :amenities, :reservation_length, :integer, default: 1
    add_column :amenities, :reservation_length_type, :string, default: 'hours'
    add_column :amenities, :max_reservations_per_user, :integer, default: 1
    add_column :amenities, :max_reservations_per_user_type, :string, default: 'days'
    add_column :amenities, :auto_approval, :boolean, default: false
  end
end