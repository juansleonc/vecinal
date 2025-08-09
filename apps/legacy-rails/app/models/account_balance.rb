class AccountBalance < ActiveRecord::Base
  
  ALLOWED_ATTACHMENT_EXTENSIONS = %w(xls xlsx)

  belongs_to :publisher, class_name: 'User', foreign_key: 'user_id'
  belongs_to :community, polymorphic: true
  has_many :user_balances, dependent: :destroy
  
  has_one :attachment, as: :attachmentable, dependent: :destroy
  accepts_nested_attributes_for :attachment, allow_destroy: true

  validates :publisher, presence: true
  validates :subject, presence: true
  validates :publication_date, presence: true
  validates :attachment, presence: true
  validate :community_inclusion

  def self.create_user_balances_from_file file, account_balance

    row = 13 # Initial row

    while not_is_the_end?(file, row) 
      row_data = file.row(row).compact
      user_balance = UserBalance.new(
        account_balance: account_balance,
        apartment_number: row_data[0],
        resident_name: row_data[1].strip,
        billing_number: row_data[3].to_i,
      )

      row += 1

      # Creates user balance items
      while item_row?(file, row)
        row_data = file.row(row).compact
        UserBalanceItem.create(
          user_balance: user_balance,
          reference_code: row_data[0],
          concept: row_data[1],
          previous_balance: row_data[2].to_s,
          current_payment: row_data[3].to_s,
          total: row_data[4].to_s
        )
        row += 1
      end

      row_data = file.row(row).compact
      if row_data[0] == "PAGO ANTERIOR:"
        user_balance.previous_payment = row_data[1].to_s
        user_balance.total = row_data[3].to_s
        user_balance.save
      end

      row += 3
    end
  end

  private

  def self.not_is_the_end? xls, row
    row <= xls.last_row && xls.row(row).compact.length > 1
  end

  def self.item_row? file, row
    data = file.row(row).compact
    data[0].present? && data[0] != "PAGO ANTERIOR:"
  end

  def community_inclusion
    unless publisher.present? && community_type == "Building" && publisher.buildings.ids.include?(community_id)
      errors.add :community_id, :inclusion
      return false
    end
  end

end