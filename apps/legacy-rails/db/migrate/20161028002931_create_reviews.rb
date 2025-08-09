class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer     :rank
      t.string      :comment
      t.references  :user, index: true
      t.references  :reviewable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
