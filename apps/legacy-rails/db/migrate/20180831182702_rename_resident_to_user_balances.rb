class RenameResidentToUserBalances < ActiveRecord::Migration
  def change
    rename_column :user_balances, :resident, :resident_name
  end
end
