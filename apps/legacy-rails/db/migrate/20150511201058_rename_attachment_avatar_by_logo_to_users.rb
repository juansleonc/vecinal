class RenameAttachmentAvatarByLogoToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :avatar_file_name, :logo_file_name
      t.rename :avatar_content_type, :logo_content_type
      t.rename :avatar_file_size, :logo_file_size
      t.rename :avatar_updated_at, :logo_updated_at
    end
  end
end
