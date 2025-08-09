class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :sender, index: true
      t.references :receiver, index: true
      t.string :title
      t.text :content
      t.boolean :urgent
      t.boolean :notify_user
      t.boolean :add_to_sticky_notes

      t.timestamps
    end
  end
end
