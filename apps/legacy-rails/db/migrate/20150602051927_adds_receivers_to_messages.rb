class AddsReceiversToMessages < ActiveRecord::Migration

  def up
    change_table :messages do |t|
      t.remove :receiver_id
      t.text :receivers
      t.string :receiver_type
    end
  end

  def down
    change_table :messages do |t|
      t.remove :receiver_type
      t.remove :receivers
      t.references :receiver, index: true
    end
  end

end
