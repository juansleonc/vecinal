class AddStripeChargeIdToDealPruchases < ActiveRecord::Migration
  def change
    add_column :deal_purchases, :stripe_charge_id, :string
  end
end
