class AddAccountBalanceIdToUserBalances < ActiveRecord::Migration
  def change
    add_column :user_balances, :account_balance_id, :integer
    add_index :user_balances, :account_balance_id
  end
end
