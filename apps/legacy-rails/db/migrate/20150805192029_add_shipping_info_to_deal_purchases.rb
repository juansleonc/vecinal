class AddShippingInfoToDealPurchases < ActiveRecord::Migration
  def change
    change_table :deal_purchases do |t|
      t.string :address
      t.string :city
      t.string :region
      t.string :country
    end
  end
end