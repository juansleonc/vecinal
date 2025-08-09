class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachmentable_type
      t.integer :attachmentable_id
      t.attachment :file_attachment

      t.timestamps
    end
  end
end
