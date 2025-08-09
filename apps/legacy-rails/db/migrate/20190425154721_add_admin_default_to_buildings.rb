class AddAdminDefaultToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :admin_default_requests, :integer, default: 0
  end
end
