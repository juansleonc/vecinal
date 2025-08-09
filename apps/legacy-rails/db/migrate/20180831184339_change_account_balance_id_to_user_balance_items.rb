class ChangeAccountBalanceIdToUserBalanceItems < ActiveRecord::Migration
  def change
    rename_column :user_balance_items, :account_balance_id, :user_balance_id
  end
end
