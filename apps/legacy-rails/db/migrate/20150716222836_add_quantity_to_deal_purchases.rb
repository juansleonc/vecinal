class AddQuantityToDealPurchases < ActiveRecord::Migration
  def change
    add_column :deal_purchases, :quantity, :integer, default: 1
  end
end
