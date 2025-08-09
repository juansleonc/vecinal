class CreatePaymentFees < ActiveRecord::Migration
  def change
    create_table :payment_fees do |t|
      t.string :platform, unique: true
      t.decimal :bank_discount_percent, precision: 5, scale: 2
      t.decimal :platform_fee, precision: 8, scale: 2
      t.decimal :cm_fee, precision: 8, scale: 2

      t.timestamps
    end
  end
end
