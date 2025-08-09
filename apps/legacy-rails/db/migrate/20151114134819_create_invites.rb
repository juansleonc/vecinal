class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :inviter, index: true
      t.string :email
      t.index :email
      t.string :accountable_type
      t.integer :accountable_id
      t.string :role

      t.timestamps
    end
  end
end
