class AddManagedByToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :managed_by, :string
  end
end
