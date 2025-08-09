class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.integer     :day
      t.time        :time_from
      t.time        :time_to
      t.boolean     :active, default: true
      t.references  :amenity, index: true

      t.timestamps
    end
  end
end
