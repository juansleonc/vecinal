class CreateAdminDetails < ActiveRecord::Migration
  def change
    create_table :admin_details do |t|
      t.references :user, index: true
      t.string :title_position
      t.string :department
      t.string :phone
      t.string :extension
      t.timestamps
    end
  end
end
