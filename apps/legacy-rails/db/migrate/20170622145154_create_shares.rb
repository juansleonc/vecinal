class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :shareable, polymorphic: true, index: true
      t.references :recipientable, polymorphic: true, index: true
    end
  end
end
