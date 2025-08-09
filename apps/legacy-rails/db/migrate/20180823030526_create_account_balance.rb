class CreateAccountBalance < ActiveRecord::Migration
  def change
    create_table :account_balances do |t|
      t.string :subject
      t.date :upload_date
      t.time :upload_time
      t.integer :user_id
      t.integer :community_id
      t.string :community_type
      t.string :co_ownership
      t.string :co_owner
      t.decimal :previous_payment
      t.decimal :total

      t.timestamps
    end

    add_index :account_balances, :user_id
  end
end
