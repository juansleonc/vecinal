class MergeUserTypeFieldsInContactDetails < ActiveRecord::Migration
  def change
    add_column :contact_details, :user_type, :string, limit: 10
    remove_column :contact_details, :tenant, :boolean
    remove_column :contact_details, :owner, :boolean
  end
end
