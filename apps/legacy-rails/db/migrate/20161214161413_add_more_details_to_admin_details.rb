class AddMoreDetailsToAdminDetails < ActiveRecord::Migration
  def change
    add_column :admin_details, :sex, :string
    add_column :admin_details, :work, :string, default: 'Demo management'
    add_column :admin_details, :education, :string
    add_column :admin_details, :birth_day, :date
    add_column :admin_details, :birth_year, :integer
    add_column :admin_details, :mobile_phone, :string
    add_column :admin_details, :relationship, :string
    add_column :admin_details, :hometown, :string
  end
end
