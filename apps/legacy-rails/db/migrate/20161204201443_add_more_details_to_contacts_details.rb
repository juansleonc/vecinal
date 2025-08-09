class AddMoreDetailsToContactsDetails < ActiveRecord::Migration
  def change
    add_column :contact_details, :sex, :string
    add_column :contact_details, :work, :string
    add_column :contact_details, :education, :string
    add_column :contact_details, :from, :string
    add_column :contact_details, :birth_day, :date
    add_column :contact_details, :birth_year, :integer
    add_column :contact_details, :mobile_phone, :string
    add_column :contact_details, :garage, :string
    add_column :contact_details, :locker, :string
    add_column :contact_details, :links, :string
    add_column :contact_details, :relationship, :string
    add_column :contact_details, :hometown, :string
  end
end