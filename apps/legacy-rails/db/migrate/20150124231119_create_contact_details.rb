class CreateContactDetails < ActiveRecord::Migration
  def change
    create_table :contact_details do |t|
      t.integer :user_id
      t.string :apartment_number
      t.string :phone
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.boolean :tenant
      t.boolean :owner

      t.timestamps
    end
  end
end
