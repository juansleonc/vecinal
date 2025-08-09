class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.references :father, index: true
      t.references :created_by, index: true
      t.references :folderable, polymorphic: true, index: true
      t.string :name
      t.integer :level

      t.timestamps
    end
  end
end
