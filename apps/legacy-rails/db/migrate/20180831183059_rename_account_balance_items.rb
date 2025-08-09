class RenameAccountBalanceItems < ActiveRecord::Migration
  def change
    rename_table :account_balance_items, :user_balance_items
  end
end
