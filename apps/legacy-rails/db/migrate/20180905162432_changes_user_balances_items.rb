class ChangesUserBalancesItems < ActiveRecord::Migration
  def change
    change_column :user_balance_items, :previous_balance, :float
    change_column :user_balance_items, :current_payment, :float
  end
end
