class AddApartmentNumberToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :apartment_number, :integer
  end
end
