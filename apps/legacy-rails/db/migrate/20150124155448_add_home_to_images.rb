class AddHomeToImages < ActiveRecord::Migration
  def change
    add_column :images, :home, :boolean
  end
end
