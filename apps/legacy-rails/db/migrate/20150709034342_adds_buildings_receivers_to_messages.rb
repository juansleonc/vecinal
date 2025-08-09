class AddsBuildingsReceiversToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :buildings_receivers, :text
  end
end
