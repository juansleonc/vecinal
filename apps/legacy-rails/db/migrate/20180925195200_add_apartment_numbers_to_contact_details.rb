class AddApartmentNumbersToContactDetails < ActiveRecord::Migration
  def change
    add_column :contact_details, :apartment_numbers, :text
  end
end
