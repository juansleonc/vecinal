class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.references :building, index: true
      t.string :apartment_number
      t.string :category
      t.date :available_at
      t.string :show_price
      t.integer :price
      t.integer :size_ft2
      t.string :bedrooms
      t.string :bathrooms
      t.boolean :furnished
      t.boolean :pets
      t.string :show_contact
      t.string :secondary_phone_number
      t.string :secondary_email
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
