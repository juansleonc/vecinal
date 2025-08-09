class AddAttachmentLogoToBusinesses < ActiveRecord::Migration
   def up
    change_table :businesses do |t|
      t.attachment :logo
    end
  end

  def down
    remove_attachment :businesses, :logo
  end
end
