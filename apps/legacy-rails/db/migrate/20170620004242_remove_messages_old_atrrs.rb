class RemoveMessagesOldAtrrs < ActiveRecord::Migration
  def up
    change_table :messages do |t|
      t.remove :notify_user, :add_to_sticky_notes, :receivers, :receiver_type, :buildings_receivers
    end
  end

  def down
    change_table :messages do |t|
      t.boolean :notify_user
      t.boolean :add_to_sticky_notes
      t.text    :receivers
      t.string  :receiver_type, limit: 255
      t.text    :buildings_receivers
    end
  end
end
