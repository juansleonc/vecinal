class CouponRedemption < ActiveRecord::Base

  belongs_to :user
  belongs_to :coupon

  validates :user_id, presence: true
  validates :coupon_id, presence: true
  validate :coupon_redeemable, on: :create

  after_create :update_coupons_number

  def update_coupons_number
    self.coupon.update number: coupon.number - 1
  end

  def self.find_current_or_create(user_id, coupon_id)
    coupon_redemption = where(user_id: user_id, coupon_id: coupon_id).where('created_at > ?', 1.day.ago).first
    coupon_redemption || create(user_id: user_id, coupon_id: coupon_id)
  end

  def printable_id
    '#' + '%06d' % self.id
  end

  def self.batch_redeem(query, business)
    ids = query.split(',').map { |q| q.to_i }
    redemptions = where id: ids, coupon_id: business.coupons
    redemptions.update_all redeemed: true
    redemptions
  end

  def coupon_redeemable
    errors.add(:base, :no_coupons_available) if self.coupon.number <= 0
    errors.add(:coupon, :not_available_yet) if self.coupon.available_at > Time.zone.now
    errors.add(:coupon, :currently_unavailable) if self.coupon.finish_at < Time.zone.now
  end

end
