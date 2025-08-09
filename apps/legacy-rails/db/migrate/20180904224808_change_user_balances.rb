class ChangeUserBalances < ActiveRecord::Migration
  def change
    change_column :user_balances, :previous_payment, :float
    change_column :user_balances, :total, :float
  end
end
