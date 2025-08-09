class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references  :user
      t.references  :likeable, polymorphic: true
      t.string      :name, default: 'like' # for future implementation for another like types (love, haha, angry, wow, sad, etc)

      t.timestamps null: false
    end

    add_index :likes, [:user_id, :likeable_id, :likeable_type], unique: true

  end
end
