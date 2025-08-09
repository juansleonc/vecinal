class AddDeletedAtToPollVote < ActiveRecord::Migration
  def change
    add_column :poll_votes, :deleted_at, :datetime
    add_index :poll_votes, :deleted_at
  end
end
