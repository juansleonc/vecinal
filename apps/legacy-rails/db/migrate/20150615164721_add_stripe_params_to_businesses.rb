class AddStripeParamsToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :stripe_user_id, :string
    add_column :businesses, :stripe_publishable_key, :string
  end
end
