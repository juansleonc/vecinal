class AddChangePasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :change_password, :boolean, default: false
  end
end
