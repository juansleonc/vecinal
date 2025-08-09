class AddDeletedAtToServiceRequest < ActiveRecord::Migration
  def change
    add_column :service_requests, :deleted_at, :datetime
    add_index :service_requests, :deleted_at
  end
end
