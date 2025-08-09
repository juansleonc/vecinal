module Shareable
  extend ActiveSupport::Concern

  RECIPIENT_TYPES = %w[Company Building MyCommunities]

  included do
    attr_accessor :recipient_type, :recipient_id

    has_many :shares, as: :shareable, dependent: :destroy
    validates :recipient_type, inclusion: { in: RECIPIENT_TYPES, allow_blank: true }

    after_create :create_recipients
  end

  def recipient
    if shares.blank?
      Public.new
    elsif shares.count == 1
      shares.first.recipientable
    elsif shares.count > 1
      MyCommunities.new self
    end
  end

  class_methods do

    def shared_public_not_contact(user)
      shared_public.where publisher: User.near_by_community(user.accountable, self::DISTANCE_FOR_PUBLICS).where.not(id: user.contacts.ids << user.id)
    end

    def filtered_for(user, filter, only_visible = true)
      return self unless user
      case filter
      when 'public'
        self.shared_public_not_contact(user)
      when 'user'
        self.where(publisher: user)
      when 'hidden_or_reported'
        marked_with_no_visible_labels_for(user)
      when 'reported'
        if user.role == 'resident'
          self.marked_with(user, filter)
        elsif user.role == 'administrator'
          self.reported_marks_for user
        end
      when 'hidden', 'saved'
        self.marked_with(user, filter)
      else
        elements = self.where(publisher: user.contacts.ids << user.id)
        elements.visible_for user
      end
    end
  end

private

  def create_recipients
    if recipient_type == 'MyCommunities'
      shares << publisher.communities.map{ |c| Share.new(recipientable: c) }
    elsif recipient_type.present? && recipient_id.present?
      shares.create recipientable_id: recipient_id, recipientable_type: recipient_type
    end
  end

end

class Public

  def id
    0
  end

  def name
    'Public'
  end

  def method_missing(method_name, *args, &block)
    ''
  end

  def contacts
    []
  end
end


class MyCommunities

  def initialize(shareable)
    @shareable = shareable
  end

  def id
    0
  end

  def name
    'My Communities'
  end

  def method_missing(method_name, *args, &block)
    ''
  end

  def contacts
    @shareable.publisher.contacts
  end

end
