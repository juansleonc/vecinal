class Promotion < ActiveRecord::Base

  TYPES = %w[Deal Coupon]
  CONTACT_OPTIONS = %w[business_details other]
  CATEGORIES = %w[food_and_drink local_services things_to_do boutique getaways beauty_and_spas health_and_fitness]

  belongs_to :business
  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :business_id, presence: true
  validates :type, presence: true, inclusion: { in: TYPES, allow_blank: false }
  validates :category, presence: true, inclusion: { in: CATEGORIES, allow_blank: true }
  validates :title, presence: true
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 0} # waitting for a verdict of this
  validates :show_contact, presence: true, inclusion: { in: CONTACT_OPTIONS, allow_blank: true }
  validates :secondary_phone_number, presence: true, if: :show_contact?
  validates :secondary_email, presence: true, format: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i, if: :show_contact?
  validates :available_at, presence: true
  validates :finish_at, presence: true
  validates :last_day_to_claim, presence: true
  validates :sign_agreement, acceptance: true
  validates :images, presence: true

  before_save :validates_weeks_after_end
  before_save :process_payment

  scope :valid, lambda { where('number > 0 AND available_at <= ? AND finish_at >= ?', Time.zone.now, Time.zone.now) }
  scope :intop, lambda { where('top >= ?', Time.zone.now).order 'top DESC' }
  scope :outtop, lambda { where('top < ? OR top IS ?', Time.zone.now, nil).order updated_at: :desc }
  scope :scheduled, lambda { where 'available_at > ?', Time.zone.now }
  scope :expired, lambda { where 'finish_at < ? OR number <= ?', Time.zone.now, 0 }

  attr_accessor :highlight_days, :top_days, :stripe_card_token, :show_highlight, :show_top, :flash_error

  def main_image
    images.where(home: true).first || images.first || images.build
  end

  def show_contact?
    show_contact == 'other'
  end

  def contact_phone
    show_contact == 'company_details' ? business.phone : secondary_phone_number
  end

  def contact_email
    show_contact == 'company_details' ? business.email : secondary_email
  end

  def split_description
    self.description.strip.split("\n")
  end

  def split_fine_print
    self.fine_print.strip.split("\n")
  end

  def process_payment
    self.business.update_stripe_customer_card(self.stripe_card_token) if self.stripe_card_token.present?
    charge_highlight if self.show_highlight == '1'
    charge_top if self.show_top == '1'
  rescue Stripe::CardError => e
    # Card declined
    self.flash_error = e.message
    return false
  rescue => e
    # Something else happened, show a generic error message (we don't want the user to find out about API/Request/Authentication errors)
    self.flash_error = Rails.env.production? ? I18n.t('general.generic_error_message') : e.message
    return false
  end

  def charge_highlight
    amount_in_cents = (highlight_prices_map[self.highlight_days].to_f * 100).to_i
    description = I18n.t('general.highlight') + ' ' + I18n.t('general.days_for_price', days: self.highlight_days, price: highlight_prices_map[self.highlight_days].to_f)
    stripe_charge = create_stripe_charge(amount_in_cents, description)
    self.stripe_highlight_charge = stripe_charge.id
    self.highlight = Time.zone.now + self.highlight_days.to_i.days
  end

  def charge_top
    amount_in_cents = (top_prices_map[self.top_days].to_f * 100).to_i
    description = I18n.t('general.top') + ' ' + I18n.t('general.days_for_price', days: self.top_days, price: top_prices_map[self.top_days].to_f)
    stripe_charge = create_stripe_charge(amount_in_cents, description)
    self.stripe_top_charge = stripe_charge.id
    self.top = Time.zone.now + self.top_days.to_i.days
  end

  def create_stripe_charge(amount_in_cents, description)
    Stripe::Charge.create({
        amount: amount_in_cents,
        currency: self.business.currency,
        description: self.title + ', ' + description,
        customer: self.business.stripe_customer_id
      }
    )
  end

  def highlight?
    self.highlight && self.highlight >= Time.zone.now
  end

  def active?
    number > 0 && available_at <= Time.zone.now && finish_at >= Time.zone.now
  end

  def status
    status = if active?
      'active'
    elsif self.available_at > Time.zone.now
      'scheduled'
    else
      'expired'
    end
  end

  def validates_weeks_after_end
    n_weeks = Rails.application.secrets.weeks_to_claim_vouchers || 4
    if self.last_day_to_claim && (self.finish_at + n_weeks.to_i.weeks) > self.last_day_to_claim
      errors.add(:last_day_to_claim, :minimum_4_weeks_after_end)
      return false
    end
  end

  def self.add_impressions(promos)
    promos.each { |promo| promo.update_column :impressions, promo.impressions + 1 }
  end

  def add_click
    self.update_column :clicks, self.clicks += 1
  end

end