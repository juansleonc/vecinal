class CreateCouponRedemptions < ActiveRecord::Migration
  def change
    create_table :coupon_redemptions do |t|
      t.references :user, index: true
      t.references :coupon, index: true
      t.boolean :redeemed, default: false

      t.timestamps
    end
  end
end
