class AddMoveInDateToContactDetails < ActiveRecord::Migration
  def change
    add_column :contact_details, :move_in_date, :datetime
  end
end
