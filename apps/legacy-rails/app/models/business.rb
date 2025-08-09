class Business < ActiveRecord::Base

  include Accountable
  include HasLogo
  include StripeCalls
  include Reviewable
  include Geocodeable

  belongs_to :owner, foreign_key: 'user_id', class_name: 'User'
  has_many :images, as: :imageable, dependent: :destroy
  has_many :promotions, dependent: :restrict_with_error
  has_many :deals, dependent: :restrict_with_error
  has_many :coupons, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :destroy # Wall posts

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :name, presence: true
  validates :phone, presence: true
  validates :namespace, presence: true, format: { with: /\A[a-z\-\_0-9]*\z/, message: :namespace_format}, length: { maximum: 30 }, uniqueness: true
  validates :email, format: { with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i, allow_blank: true }
  validates :country, presence: true
  validates :region, presence: true
  validates :city, presence: true
  validates :address, presence: true
  # validates :zip, presence: true
  validates :confirm_legal_representation, acceptance: true

  after_create do
    create_stripe_subscription plan_id: 'sup_basic'
  end

  scope :near_reference, lambda { |reference, distance|
    near([reference.latitude, reference.longitude], distance, units: DISTANCE_UNITS)
  }

  def to_param
    namespace
  end

  def home_image
    self.images.where(home: true).first || ImageBusiness.new
  end

  def full_address
    "#{address}, #{city}, #{region}, #{zip}, #{country}"
  end

  def display_address
    "#{address}, #{city}, #{zip}"
  end

  def map_pop_over_url
    'businesses/map_pop_over'
  end

  def currency
    'cad'
  end

  def application_fee
    fee = Rails.application.secrets.application_fee_percent
    fee ? fee.to_f/100 : 0.2
  end

  def can_create_coupons?
    return false unless %w[active past_due].include?(self.stripe_subscription_status)
    number_coupons = self.coupons.unexpired.count
    (self.stripe_subscription_plan == 'sup_basic' && number_coupons < max_coupons_on_basic_plan) ||
    (self.stripe_subscription_plan == 'sup_premium' && number_coupons < max_coupons_on_premium_plan) ||
    (self.stripe_subscription_plan == 'sup_pro' && number_coupons < max_coupons_on_pro_plan)
  end

  def max_coupons_on_basic_plan
    (Rails.application.secrets.max_coupons_on_basic_plan || 1).to_i
  end

  def max_coupons_on_premium_plan
    (Rails.application.secrets.max_coupons_on_premium_plan || 3).to_i
  end

  def max_coupons_on_pro_plan
    (Rails.application.secrets.max_coupons_on_pro_plan || 6).to_i
  end

  def plans
    stripe_plans 'sup'
  end

  def distance_rounded(geo_object, precision = 1)
    "#{(self.distance_from geo_object, DISTANCE_UNITS).round precision} #{DISTANCE_UNITS}" if self.geocoded?
  rescue
    return ''
  end

  def valid_promos
    self.promotions.valid.intop + self.promotions.valid.outtop
  end

  def ordered_promotions
    self.promotions.valid + self.promotions.scheduled + self.promotions.expired
  end

  def validates_upgrade_downgrade_plan(old_plan, new_plan)
    number_coupons = self.coupons.unexpired.count
    if (old_plan == new_plan) || (old_plan == 'sup_basic') || (new_plan == 'sup_pro') ||
      (new_plan == 'sup_basic' && number_coupons <= max_coupons_on_basic_plan) ||
      (new_plan == 'sup_premium' && number_coupons <= max_coupons_on_premium_plan)
      return true
    else
      errors.add :base, :can_not_update_plan
      return false
    end
  end

  def payments
    DealPurchase.where(deal_id: self.deals).order created_at: :desc
  end

  def link_to_subscriptions
    Rails.application.routes.url_helpers.business_stripe_subscription_path(self.namespace)
  end

  def coupons_by_plan(plan)
    case plan
      when 'sup_basic' then max_coupons_on_basic_plan
      when 'sup_premium' then max_coupons_on_premium_plan
      when 'sup_pro' then max_coupons_on_pro_plan
    end
  end

end
