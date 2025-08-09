json.array!(@apartments) do |apartment|
  json.extract! apartment, :id, :building_id, :apartment_number, :category, :available_at, :show_price, :price, :size_ft2, :bedrooms, :bathrooms, :furnished, :pets, :show_contact, :secondary_phone_number, :secondary_email, :title, :description
  json.url apartment_url(apartment, format: :json)
end
