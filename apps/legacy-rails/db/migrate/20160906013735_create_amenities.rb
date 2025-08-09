class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.references  :building, index: true
      t.string      :name
      t.text        :description
      t.boolean     :rental_fee, default: false
      t.decimal     :rental_value, precision: 11, scale: 2
      t.boolean     :deposit, default: false
      t.decimal     :deposit_value, precision: 11, scale: 2
      t.integer     :maximun_rental_time
      t.string      :availability_type, default: 'selected_hours'

      t.timestamps
    end
  end
end
