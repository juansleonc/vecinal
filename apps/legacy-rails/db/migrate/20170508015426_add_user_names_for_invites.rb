class AddUserNamesForInvites < ActiveRecord::Migration
  def change
    add_column :invites, :first_name, :string
    add_column :invites, :last_name, :string
  end
end
