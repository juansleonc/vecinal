class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.references :company
      t.string :code
      t.string :name
      t.string :subdomain
      t.text :description
      t.integer :size
      t.string :category
      t.string :address
      t.string :city
      t.string :region
      t.string :country
      t.string :zip
      t.attachment :logo

      t.timestamps
    end
  end
end
