class AddDeletedAtToAmenity < ActiveRecord::Migration
  def change
    add_column :amenities, :deleted_at, :datetime
    add_index :amenities, :deleted_at
  end
end
