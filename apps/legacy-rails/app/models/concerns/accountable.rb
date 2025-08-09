module Accountable
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, foreign_key: 'user_id', class_name: 'User'
    has_many :admins,->{ where(role: 'administrator')} ,class_name: 'User', as: :accountable
    has_many :collaborators,->{ where(role: 'collaborator')} ,class_name: 'User', as: :accountable

    
    validate :owner_has_no_role

    before_create :set_code
    after_create :set_owners_accountable
    after_create :auto_accept_owner
  end

  def owner_has_no_role
    if id.blank? and owner.try(:role).present?
      errors.add(:user_id, :owner_has_a_role_already)
    end
  end

  def set_owners_accountable
    self.owner.update(accountable: self)
  end

  def auto_accept_owner
    self.owner.update(accepted: true)
  end

  def set_code
    self.code = SecureRandom.hex(3)
    while self.class.where(code: code).first.present?
      self.code = SecureRandom.hex(3)
    end
  end

  # methods defined here are going to extend the class, not the instance of it
  class_methods do
  end

end