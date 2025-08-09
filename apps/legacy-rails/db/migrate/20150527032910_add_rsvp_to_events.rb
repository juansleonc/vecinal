class AddRsvpToEvents < ActiveRecord::Migration
  def change
    add_column :events, :rsvp, :boolean
  end
end
