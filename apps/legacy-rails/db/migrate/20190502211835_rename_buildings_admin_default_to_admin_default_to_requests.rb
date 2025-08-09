class RenameBuildingsAdminDefaultToAdminDefaultToRequests < ActiveRecord::Migration
  def change
    rename_column :buildings, :admin_default, :admin_default_requests
    add_column :buildings, :admin_default_reservations, :integer, default: 0
  end
end
