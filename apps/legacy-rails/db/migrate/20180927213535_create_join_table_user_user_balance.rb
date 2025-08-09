class CreateJoinTableUserUserBalance < ActiveRecord::Migration
  def change
    create_join_table :users, :user_balances do |t|
      t.index [:user_id, :user_balance_id]
    end
  end
end
