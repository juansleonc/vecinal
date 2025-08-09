class AddClaimShippingImpressionsClicksToPromotions < ActiveRecord::Migration
  def change
    change_table :promotions do |t|
      t.datetime :last_day_to_claim
      t.boolean :requires_shipping
      t.integer :impressions, default: 0
      t.integer :clicks, default: 0
    end
  end
end
