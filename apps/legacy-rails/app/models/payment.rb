class Payment < ActiveRecord::Base

  include Countable

  PER_PAGE = 50

  belongs_to :user
  belongs_to :payment_account
  has_one :building, through: :payment_account

  scope :by_building, -> (building) { joins(:payment_account).where payment_accounts: { building_id: building } }

  scope :search_by, -> (query) { distinct.joins(payment_account: :building ).where(
    'payments.description ILIKE :query OR payments.customer_name ILIKE :query OR payments.customer_lastname ILIKE :query OR payment_accounts.bank_name ILIKE :query OR payment_accounts.status ILIKE :query OR buildings.name ILIKE :query',
    query: "%#{query}%"
  )}

  def self.transactions_count start, final, users
    presents_beetwen(start, final, users).count
  end

  def self.amount_count start, final, users
    presents_beetwen(start, final, users).sum(:amount)
  end

  def payer_full_name
    "#{customer_name} #{customer_lastname}"
  end

end
