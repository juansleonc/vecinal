class Apartment < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper

  CATEGORIES = %w[for_rent for_sale only_display]
  BEDROOMS_OPTIONS = %w[one two three four more]
  BATHROOMS_OPTIONS = %w[one one_and_half two two_and_half three three_and_half four more]
  PRICE_OPTIONS = %w[set_price please_contact]
  CONTACT_OPTIONS = %w[company_details other]

  belongs_to :building
  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :building_id, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES, allow_blank: true }
  validates :available_at, presence: true, unless: :only_display?
  validates :show_price, presence: true, inclusion: { in: PRICE_OPTIONS, allow_blank: true }, unless: :only_display?
  validates :price, presence: true, if: "show_price?"
  validates :bedrooms, presence: true, inclusion: { in: BEDROOMS_OPTIONS, allow_blank: true }
  validates :bathrooms, presence: true, inclusion: { in: BATHROOMS_OPTIONS, allow_blank: true }
  validates :show_contact, presence: true, inclusion: { in: CONTACT_OPTIONS, allow_blank: true }
  validates :secondary_phone_number, presence: true, if: "show_contact?"
  validates :secondary_email, presence: true, if: "show_contact?"
  validates :description, presence: true
  validates :images, presence: true

  before_save :update_category_dependecies

  def main_image
    self.images.where(home: true).first || self.images.first || self.images.build
  end

  def show_price?
    show_price == 'set_price'
  end

  def show_contact?
    show_contact == 'other'
  end

  def final_price
    return '' if self.category == 'only_display'
    show_price == 'please_contact' ? show_price_translation : number_to_currency(price)
  end

  def category_translation
    I18n.t("general.apartment_categories.#{category}")
  end

  def bedrooms_translation
    I18n.t("general.apartment_bedrooms.#{bedrooms}")
  end

  def bathrooms_translation
    I18n.t("general.apartment_bathrooms.#{bathrooms}")
  end

  def show_price_translation
    I18n.t("general.apartment_price_options.#{show_price}")
  end

  def show_contact_translation
    I18n.t("general.apartment_contact_options.#{show_contact}")
  end

  def furnished_translation
    furnished ? I18n.t("general.yes_word") : I18n.t("general.no_word")
  end

  def pets_translation
    pets ? I18n.t("general.yes_word") : I18n.t("general.no_word")
  end

  def contact_phone
    show_contact == 'company_details' ? self.building.company.phone : secondary_phone_number
  end

  def contact_email
    show_contact == 'company_details' ? self.building.company.email : secondary_email
  end

  def only_display?
    self.category == 'only_display'
  end

  def safe_available_at
    self.available_at.present? ? self.available_at.strftime("%B %e") : 'N/A'
  end

  private

    def update_category_dependecies
      if only_display?
        self.show_price = nil
        self.price = nil
        self.available_at = nil
      end
    end

end
