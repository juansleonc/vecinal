class AddBillingInfoAndCommunityIdToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :community_id, :string, default: ''
    add_column :buildings, :billing_information, :text, default: ""
  end
end
