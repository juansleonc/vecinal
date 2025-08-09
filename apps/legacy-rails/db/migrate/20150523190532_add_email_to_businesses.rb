class AddEmailToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :email, :string, after: :phone
  end
end
