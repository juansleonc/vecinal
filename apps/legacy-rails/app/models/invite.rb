class Invite < ActiveRecord::Base

  belongs_to :inviter, class_name: 'User'
  belongs_to :accountable, polymorphic: true

  validate :email_valid?
  validate :already_member?
  validates :inviter_id, presence: true
  validates :email, presence: true
  validates :accountable_id, presence: true
  validates :accountable_type, presence: true

  serialize :emails

  scope :all_by_inviter, -> (inviter_in) { where 'inviter_id = ?', inviter_in }

  scope :by_company, -> (company) { where inviter: company.administrators }

  before_validation :set_role
  after_create :send_email
  after_create :check_pendings
  # after_create :accept_user_with_registration_pending

  scope :search_by, -> (query) { distinct.where(
    'email ILIKE :query OR first_name ILIKE :query OR last_name ILIKE :query',
    query: "%#{query}%"
  )}

  def self.qty_invites_by_accountable(current_user)
    communities_invites = Invite.by_company(current_user.my_company).group([:accountable_type,:accountable_id]).count
    qty_invites = [];
    communities_invites.each do |key, value|
      qty_invites.push(key[0].to_s + '-' + key[1].to_s => value.to_i)
    end
    qty_invites
  end

  def send_email
    UserMailer.new_invite(self).deliver_now
  end

  def email_valid?
    return false if email.blank?
    return true if email.match(/\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i).present?
    errors.add :base, I18n.t('invites.invalid_email_format', email: email)
    return false
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def accept_by_user(user)
    if user == User.where(accepted: false).find_by_email(email)
      transaction do
        user.update(
          accountable: self.accountable,
          role: self.role,
          accepted: true
        )

        user_details = user.contact_details
        user_details.apartment_numbers << self.apartment_number
        user_details.save

        Invite.where(email: email).destroy_all
      end
    end
  end

private

  def set_role
    
    unless inviter.communities.include? accountable
      errors.add :base, :community_not_exists
      return false
    end

  end

  def administrator?
    self.role == 'administrator'
  end

  def already_member?
    if User.where(accepted: true).find_by_email email
      errors.add :base, 'User with this email is already a member'
      return false
    end
  end

  def check_pendings
    user_with_pendigs = User.find_by(email: email, accepted: false, accountable: accountable)
    if user_with_pendigs
      user_with_pendigs.update(accountable: accountable, role: role, accepted: true)
      self.destroy
    end
  end

  # def accept_user_with_registration_pending
  #   if user = User.where(accepted: false).find_by_email(email)
  #     user.update(accountable: accountable, role: role, accepted: true)
  #   end
  # end

end
