class CreateDealPurchases < ActiveRecord::Migration
  def change
    create_table :deal_purchases do |t|
    	t.references :user, index: true
    	t.references :deal, index: true
    	t.decimal :price, precision: 11, scale: 2
    	t.string :status

      t.timestamps
    end
  end
end
