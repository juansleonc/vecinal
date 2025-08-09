class DealPurchase < ActiveRecord::Base

  belongs_to :user
  belongs_to :deal

  STATUS = %w[not_redeemed redeemed]

  validates :status, presence: true, inclusion: { in: STATUS }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999999999.99 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :deal_buyable, on: :create
  validates :sign_agreement, acceptance: true
  with_options if: :requires_shipping? do |puchase|
    puchase.validates :address, presence: true
    puchase.validates :city, presence: true
    puchase.validates :region, presence: true
    puchase.validates :country, presence: true
  end

  before_validation :set_status
  before_create :process_payment
  after_create :notify_users

  attr_accessor :stripe_card_token

  def printable_id
    '#' + '%06d' % self.id
  end

  def self.batch_purchase(query, business)
    ids = query.split(',').map { |q| q.to_i }
    purchases = self.where id: ids, deal_id: business.deals
    purchases.update_all status: 'redeemed'
    purchases
  end

  def deal_buyable
    errors.add(:base, :no_deals_available) if self.deal.number <= 0
    errors.add(:deal, :not_available_yet) if self.deal.available_at > Time.zone.now
    errors.add(:deal, :currently_unavailable) if self.deal.finish_at < Time.zone.now
  end

  def redeemed
    self.status == STATUS[1]
  end

  def set_status
    self.status ||= STATUS.first
  end

  def process_payment
    stripe_charge = create_stripe_charge
    self.stripe_charge_id = stripe_charge.id
  rescue Stripe::CardError => e
    # Card declined
    errors.add :base, e.message
    return false
  rescue => e
    # Something else happened, show a generic error message (we don't want the user to find out about API/Request/Authentication errors)
    error = Rails.env.production? ? I18n.t('general.generic_error_message') : e.message
    errors.add :base, error
    return false
  end

  def create_stripe_charge
    amount_in_cents = (self.price * self.quantity * 100).to_i
    business = self.deal.business
    Stripe::Charge.create({
        amount: amount_in_cents,
        currency: business.currency,
        description: "#{self.deal.title} X #{self.quantity}",
        source: self.stripe_card_token,
        application_fee: (amount_in_cents * business.application_fee).to_i
      },
      stripe_account: business.stripe_user_id
    )
  end

  def requires_shipping?
    self.deal.requires_shipping
  end

  def full_address
    "#{self.address}, #{self.city}, #{self.region}" if requires_shipping?
  end

  def notify_users
    UserMailer.new_sale(self, self.user).deliver_now
    UserMailer.new_purchase(self, self.user).deliver_now
  end

end
