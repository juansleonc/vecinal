class AddDeletedAtToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :deleted_at, :datetime
    add_index :payments, :deleted_at
  end
end
