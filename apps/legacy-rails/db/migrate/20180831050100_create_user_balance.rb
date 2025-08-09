class CreateUserBalance < ActiveRecord::Migration
  def change
    create_table :user_balances do |t|
      t.string :resident
      t.string :apartment_number
      t.integer :billing_number
      t.integer :previous_payment
      t.integer :total
    end
  end
end
