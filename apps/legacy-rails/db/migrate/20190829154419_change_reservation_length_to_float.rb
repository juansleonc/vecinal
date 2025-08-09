class ChangeReservationLengthToFloat < ActiveRecord::Migration
  def change
    change_column :amenities, :reservation_length, :float
  end
end
