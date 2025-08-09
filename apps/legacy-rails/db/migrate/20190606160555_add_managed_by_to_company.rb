class AddManagedByToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :managed_by, :string
  end
end
