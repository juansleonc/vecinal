class AddNamespaceAndDescriptionToBusinesses < ActiveRecord::Migration
  def change
  	add_column :businesses, :namespace, :string
  	add_column :businesses, :description, :string
  end
end
