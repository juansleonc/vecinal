class AddTourTakenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tour_taken, :boolean, default: false
  end
end
