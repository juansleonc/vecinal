class Deal < Promotion

  HIGHLIGHT_PRICES_MAP = eval(Rails.application.secrets.deal_highlight_prices_map.to_s) || {'7' => 5, '15' => 10, '30' => 20}
  TOP_PRICES_MAP = eval(Rails.application.secrets.deal_top_prices_map.to_s) || {'7' => 10, '15' => 20, '30' => 30}

  has_many :purchases, class_name: 'DealPurchase'

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999999999.99 }
  validates :discount, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 100 }
  validates :highlight_days, inclusion: { in: HIGHLIGHT_PRICES_MAP.keys, allow_blank: true }
  validates :top_days, inclusion: { in: TOP_PRICES_MAP.keys, allow_blank: true }

  before_destroy :validate_purchases_related

  def payable_price
    (price.to_f * (1 - discount.to_f/ 100)).round 2
  end

  def saving
    price.to_f - payable_price
  end

  def self.near_by_business(object_reference)
    deals = []
    businesses = Business.near_reference(object_reference, MAX_DISTANCE_FROM_BUILDING).where id: Deal.valid.distinct.pluck(:business_id)
    businesses.each { |business| deals.concat business.deals.valid.intop }
    businesses.each { |business| deals.concat business.deals.valid.outtop }
    add_impressions deals
    { businesses: businesses, deals: deals }
  end

  def highlight_prices_map
    HIGHLIGHT_PRICES_MAP
  end

  def top_prices_map
    TOP_PRICES_MAP
  end

  def acquisitions
    DealPurchase.where(deal_id: self.id).count
  end

  def redeemed
    DealPurchase.where(deal_id: self.id, status: 'redeemed').count
  end

  def revenue
    DealPurchase.where(deal_id: self.id).sum('price * quantity')
  end

  def customers
    DealPurchase.where(deal_id: self.id).pluck(:user_id).uniq
  end

  def report
    Rails.application.routes.url_helpers.deal_purchases_path(self.id)
  end

  private

    def validate_purchases_related
      if self.purchases.any?
        errors.add :base, :cant_delete_has_purchases
        return false
      end
    end

end