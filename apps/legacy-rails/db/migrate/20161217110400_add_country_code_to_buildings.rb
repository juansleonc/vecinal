class AddCountryCodeToBuildings < ActiveRecord::Migration
  def up
    add_column :buildings, :country_code, :string, limit: 3

    Building.find_each do |b|
      b.country_code ||= b.country_code_from_geocoder
      b.save!
    end
  end

  def down
    remove_column :buildings, :country_code
  end

end
