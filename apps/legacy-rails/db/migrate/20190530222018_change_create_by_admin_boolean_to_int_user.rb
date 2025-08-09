class ChangeCreateByAdminBooleanToIntUser < ActiveRecord::Migration
  def change
    remove_column :users, :create_by_admin
    add_column :users, :create_by_admin, :integer, default: 0
  end
end
