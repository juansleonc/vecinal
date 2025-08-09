class RemoveApartmentNumberToContactDetails < ActiveRecord::Migration
  def change
    remove_column :contact_details, :apartment_number, :string
  end
end
