class UpdateApartmentNumbersToContactDetails < ActiveRecord::Migration
  def up
    ContactDetails.find_each do |contact_detail|
      if contact_detail.apartment_number.present?
        contact_detail.update(apartment_numbers: [contact_detail.apartment_number])
      end
    end
  end

  def down
  end
end
