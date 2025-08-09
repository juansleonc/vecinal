class AddCretedByToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :created_by, index: true
  end
end
