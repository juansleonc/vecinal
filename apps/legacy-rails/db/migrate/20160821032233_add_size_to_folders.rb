class AddSizeToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :size, :integer, default: 0
  end
end
