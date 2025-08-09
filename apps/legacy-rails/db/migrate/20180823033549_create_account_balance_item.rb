class CreateAccountBalanceItem < ActiveRecord::Migration
  def change
    create_table :account_balance_items do |t|
      t.string :reference_code
      t.string :concept
      t.decimal :previous_balance
      t.decimal :current_payment
      t.decimal :total

      t.timestamps
    end
  end
end
