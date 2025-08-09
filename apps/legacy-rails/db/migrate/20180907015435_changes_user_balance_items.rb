class ChangesUserBalanceItems < ActiveRecord::Migration
  def change
    change_column :user_balance_items, :previous_balance, :string
    change_column :user_balance_items, :current_payment, :string
    change_column :user_balance_items, :total, :string
  end
end
