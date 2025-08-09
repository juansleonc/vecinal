class AddCreateByAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :create_by_admin, :boolean, default: false
  end
end
