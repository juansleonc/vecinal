class PaymentAccount < ActiveRecord::Base

  include NilModels

  STATUSES = %w[active in_progress]
  STATUS_COLORS = { active: 'green', in_progress: 'yellow' }
  CURRENCIES = { CO: 'COP', CA: 'CAD', US: 'USD' }
  COUNTRIES =
  PER_PAGE = 20

  belongs_to :building
  has_many :payments, dependent: :destroy

  validates :building, presence: true, uniqueness: true
  validates :country, presence: true
  validates :bank_name, presence: true
  validates :account_name, presence: true
  validates :status, inclusion: { in: STATUSES, message: "must be in: #{STATUSES.join(', ')}" }
  validates :account_type, presence: true, if: :colombian?
  validates :transit_number, numericality: true, if: :canadian?
  validates :institution_number, numericality: true, if: :canadian?
  validates :routing_number, numericality: true, if: :american?
  validates :account_number, numericality: true
  validates :enable_payments, inclusion: { in: [true, false] }
  validates :cust_id_cliente, presence: true, on: :update
  validates :public_key, presence: true, on: :update

  before_validation :set_status

  def payment_fee
    PaymentFee.find_by_country(country) || NilPaymentFee.new
  end

private

  def set_status
    self.status ||= 'in_progress'
  end

  def colombian?
    country == 'CO'
  end

  def canadian?
    country == 'CA'
  end

  def american?
    country == 'US'
  end

  def enabled?
    status == 'active' && enable_payments?
  end

end

