class AddStripeSubscriptionToBusinesses < ActiveRecord::Migration
  def change
    change_table :businesses do |t|
      t.string :stripe_customer_id
      t.string :stripe_subscription_plan
      t.string :stripe_subscription_status
    end
  end
end
