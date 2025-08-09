class AddAccountBalanceIdToAccountBalanceItems < ActiveRecord::Migration
  def change
    add_column :account_balance_items, :account_balance_id, :integer
  end
end
