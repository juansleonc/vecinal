class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date        :date
      t.time        :time_from
      t.time        :time_to
      t.string      :status
      t.string      :payment
      t.text        :message
      t.references  :reserver, index: true
      t.references  :amenity, index: true

      t.timestamps
    end
  end
end
