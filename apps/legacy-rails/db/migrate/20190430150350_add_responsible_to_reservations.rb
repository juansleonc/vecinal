class AddResponsibleToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :responsible_id, :integer, default: 0
  end
end
