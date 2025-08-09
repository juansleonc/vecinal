class Coupon < Promotion

  HIGHLIGHT_PRICES_MAP = eval(Rails.application.secrets.coupon_highlight_prices_map.to_s) || {'7' => 5, '15' => 10, '30' => 20}
  TOP_PRICES_MAP = eval(Rails.application.secrets.coupon_top_prices_map.to_s) || {'7' => 10, '15' => 20, '30' => 30}

  has_many :redemptions, class_name: 'CouponRedemption'

  validates :highlight_days, inclusion: { in: HIGHLIGHT_PRICES_MAP.keys, allow_blank: true }
  validates :top_days, inclusion: { in: TOP_PRICES_MAP.keys, allow_blank: true }

  before_destroy :validate_redemptions_related
  before_create :can_create_coupon?
  before_update :can_update_coupon?

  scope :unexpired, lambda { where 'finish_at >= ?', Time.zone.now }

  def self.near_by_business(object_reference)
    coupons = []
    businesses = Business.near_reference(object_reference, MAX_DISTANCE_FROM_BUILDING).where id: Coupon.valid.distinct.pluck(:business_id)
    businesses.each { |business| coupons.concat business.coupons.valid.intop }
    businesses.each { |business| coupons.concat business.coupons.valid.outtop }
    add_impressions coupons
    { businesses: businesses, coupons: coupons }
  end

  def highlight_prices_map
    HIGHLIGHT_PRICES_MAP
  end

  def top_prices_map
    TOP_PRICES_MAP
  end

  def expired?
    self.finish_at_was < Time.zone.now
  end

  def acquisitions
    CouponRedemption.where(coupon_id: self.id).count
  end

  def redeemed
    CouponRedemption.where(coupon_id: self.id, redeemed: true).count
  end

  def customers
    CouponRedemption.where(coupon_id: self.id).pluck(:user_id).uniq
  end

  def revenue
    0
  end

  def can_create_coupon?
    if self.business.can_create_coupons?
      true
    else
      self.flash_error = I18n.t('coupons.can_not_create_coupon_limit_of_plan')
      false
    end
  end

  def report
    Rails.application.routes.url_helpers.coupon_redemptions_path(self.id)
  end

  private

    def validate_redemptions_related
      if self.redemptions.any?
        errors.add :base, :cant_delete_has_redemptions
        return false
      end
    end

    def can_update_coupon?
      if !self.business.can_create_coupons? && self.expired?
        self.flash_error = I18n.t('coupons.can_not_update_coupon_limit_of_plan')
        return false
      end
    end

end