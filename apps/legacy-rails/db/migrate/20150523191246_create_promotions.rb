class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.references :business, index: true
      t.string :type
      t.string :category
      t.string :title
      t.decimal :price, precision: 11, scale: 2
      t.integer :discount
      t.integer :number
      t.datetime :available_at
      t.datetime :finish_at
      t.text :description
      t.text :fine_print
      t.string :show_contact
      t.string :secondary_phone_number
      t.string :secondary_email

      t.timestamps
    end
    add_index :promotions, [:title, :price]
  end
end