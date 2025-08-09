class RemoveAddToStickyNotesFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :add_to_sticky_notes, :boolean
  end
end
