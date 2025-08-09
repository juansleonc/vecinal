class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :sender, index: true
      t.string :title
      t.string :category
      t.datetime :date
      t.string :repeat_frequency
      t.datetime :expires_at
      t.string :location
      t.string :receiver_type
      t.text :receivers
      t.text :details
      t.boolean :add_to_sticky_notes
      t.timestamps
    end
    add_index :events, :title
    add_index :events, :date
  end
end
