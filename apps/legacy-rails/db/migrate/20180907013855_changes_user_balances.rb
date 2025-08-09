class ChangesUserBalances < ActiveRecord::Migration
  def change
    change_column :user_balances, :previous_payment, :string
    change_column :user_balances, :total, :string
  end
end
