class ChangeApartmentNumberToInvites < ActiveRecord::Migration
  def change
    change_column :invites, :apartment_number, :string
  end
end
