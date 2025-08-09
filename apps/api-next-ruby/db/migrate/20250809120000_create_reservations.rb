class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations, id: :uuid do |t|
      t.uuid :amenity_id, null: false
      t.uuid :reserver_id
      t.uuid :responsible_id
      t.date :date, null: false
      t.string :time_from, null: false
      t.string :time_to, null: false
      t.string :status, null: false, default: 'pending'
      t.text :message

      t.timestamps
    end

    add_index :reservations, :amenity_id
    add_index :reservations, :reserver_id
  end
end
