class PaymentFee < ActiveRecord::Base

  PLATFOMRS = %w[epayco stripe moneris]
  COUNTRY = { CO: 'epayco', CA: 'moneris', US: 'stripe' }

  validates :platform, presence: true, uniqueness: true, inclusion: {in: PLATFOMRS, message: "must be in: #{PLATFOMRS.join(', ')}" }
  validates :bank_discount_percent, numericality: { allow_blank: true }
  validates :platform_fee, numericality: { allow_blank: true }
  validates :cm_fee, numericality: { allow_blank: true }

  def self.find_by_country(country)
    find_by_platform COUNTRY[country.to_sym]
  end

end
