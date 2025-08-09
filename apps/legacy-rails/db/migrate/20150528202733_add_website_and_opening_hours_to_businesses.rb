class AddWebsiteAndOpeningHoursToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :opening_hours, :string
    add_column :businesses, :website, :string
  end
end
