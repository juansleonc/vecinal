module Receiverable
  extend ActiveSupport::Concern

  included do
    attr_accessor :receivers

    belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'
    alias publisher sender

    alias_attribute :user, :sender

    validates :sender, presence: true
    validate :remove_empty_receivers
    before_create :cast_objects_to_users
  end

  def remove_empty_receivers
    receivers.keep_if { |receiver| receiver.present? }
    if receivers.empty?
      errors.add(:receivers, :cant_be_blank)
      return false
    end
  end

  def cast_objects_to_users
    users_ids = [sender.id]
    receivers.each do |receiver|
      receiver_type, receiver_id = receiver.split(',')
      if ['Company', 'Building'].include? receiver_type
        users_ids += sender.contacts.where(accountable_type: receiver_type, accountable_id: receiver_id).ids
        #users_ids += sender.company_contacts.ids if receiver_type == 'Building'
      elsif receiver_type == 'User'
        users_ids += sender.contacts.where(id: receiver_id).ids
      end
    end
    self.users = User.where(id: users_ids.uniq)
  end

  def company
    sender.accountable.is_a?(Company) ? sender.accountable : sender.accountable.company
  end

  class_methods do

    # def receiver_types_for(user)
    #   user.accountable.is_a?(Company) ? %w[users buildings companies] : %w[users buildings]
    # end

    def receiver_types_icon(type)
      return 'fa-user' if type == 'users'
      return 'fa-building' if type == 'buildings'
      return 'fa-home' if type == 'companies'
    end

  end

end