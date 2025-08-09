class RemoveFieldToAccountBalances < ActiveRecord::Migration
  def change
    remove_column :account_balances, :co_ownership
    remove_column :account_balances, :co_owner
    remove_column :account_balances, :previous_payment
    remove_column :account_balances, :total
    remove_column :account_balances, :billing_number
    rename_column :account_balances, :upload_date, :pulication_date
  end
end
