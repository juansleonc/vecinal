class Setting < ActiveRecord::Base

  include Attachmentable

  NAMES = %w[ 
    who_can_see_your_name
    who_can_see_your_email
    who_can_see_my_profile 
    who_can_see_my_posts 
    who_can_post_timeline 
    who_can_see_others_posts 
    who_can_see_contact_information 
    who_can_comment_posts 
    who_can_create_events 
    who_can_create_polls 
    who_can_send_messages 
    who_can_create_offers 
    who_can_review 
    email_when_message 
    email_when_reply_my_comment 
    email_when_write_on_profile 
    email_when_new_poll 
    email_when_new_event 
    email_when_new_classified 
    email_when_new_service_request 
    email_when_new_reservation 
    email_when_new_join_request 
    email_when_post_timeline
    email_when_post_timeline_reply 
    email_when_review 
    email_when_review_reply
    notification_mail_signature
    append_message_to_outgoing_notifications
  ]

  VALUES = %w[public my_community management_only community_members yes no]

  belongs_to :settingable, polymorphic: true

  validates :settingable, presence: true
  validates :name, presence: true, inclusion: { in: NAMES }
  validate  :allowed_value

  private

  def allowed_value
    if self.value.blank? || (SettingableCommunity::PROFILE_WITHOUT_PUBLIC.include?(self.name) && self.value == "public")
      errors.add(:value, "can't be public for this setting")
    end
  end

end
