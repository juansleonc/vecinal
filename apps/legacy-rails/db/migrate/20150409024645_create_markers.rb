class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers, id: false do |t|
      t.integer :markable_id
      t.string :markable_type
      t.references :user, index: true
      t.string :label

      t.timestamps
    end

    add_index :markers, [:markable_type, :markable_id]
  end
end
