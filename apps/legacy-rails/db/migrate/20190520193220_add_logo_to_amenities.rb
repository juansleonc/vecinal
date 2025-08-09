class AddLogoToAmenities < ActiveRecord::Migration
  
  def self.up
    change_table :amenities do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :amenities, :logo
  end
end
