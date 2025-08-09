class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.references :user, index: true
      t.string :code
      t.string :name
      t.string :phone
      t.string :extension
      t.string :country
      t.string :region
      t.string :city
      t.string :address
      t.string :zip

      t.timestamps
    end
  end
end
