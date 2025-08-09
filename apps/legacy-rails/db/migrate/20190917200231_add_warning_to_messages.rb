class AddWarningToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :warning, :boolean, :default => false
  end
end
