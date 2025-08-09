module Geocodeable
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_address
    after_validation :geocode, if: "address_changed? or city_changed? or region_changed? or zip_changed? or country_changed?"
  end

  # methods defined here are going to extend the class, not the instance of it
  class_methods do

    def near_by_ip(ip, dist=20, fields)
      Rails.env.development? ? all : near(ip, dist)
    end

    def nearby_from(ip, country, dist)
      where(id: where(country: country).ids + near_by_ip(ip, dist).map{|object| object.id})
    end

  end

end