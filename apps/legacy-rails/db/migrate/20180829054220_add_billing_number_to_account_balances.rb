class AddBillingNumberToAccountBalances < ActiveRecord::Migration
  def change
    add_column :account_balances, :billing_number, :integer
  end
end
