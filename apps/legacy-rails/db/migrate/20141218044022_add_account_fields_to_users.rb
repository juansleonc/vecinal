class AddAccountFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accountable_type, :string
    add_column :users, :accountable_id, :integer
    add_index  :users, [:accountable_id, :accountable_type]
  end
end
