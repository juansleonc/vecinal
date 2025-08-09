module Settingable
  extend ActiveSupport::Concern

  included do
    has_many :settings, as: :settingable
  end

  def setting_for(name)
    if setting = settings.find_by_name(name)
      setting.value
    else
      setting_default_value_for name
    end
  end

  def update_settings(params)
    current_settings = settings.where(name: params.keys).pluck :name
    params.each do |name, value|
      if current_settings.include? name
        settings.find_by_name(name).update value: value
      elsif setting_default_value_for(name) != value
        settings.create name: name, value: value
      end
    end
  end

  def check_settings(current, setting, user)
    
    if current.id == user.id
      return true
    end

    if 'who_can_see_your_name' == setting && user.role == 'administrator'
      return true
    end

    acces = [];
    case current.role
    when 'administrator'
      acces = %w[public my_community management_only]
    when 'collaborator'
      acces = %w[public my_community management_only]
    when 'board_member'
      acces = %w[public my_community]
    when 'tenant'
      acces = %w[public my_community]
    when 'agent'
      acces = %w[public my_community]
    when 'resident'
      acces = %w[public my_community]
    else
      acces = %w[public]
    end

    acces.include? user.setting_for(setting)
  end

  class_methods do
    def public_setting_for(name)
      joins(:settings).where settings: {name: name, value: 'public'}
    end
  end

end

module SettingableUser
  PROFILE = %w[who_can_see_your_name who_can_see_your_email who_can_see_my_profile who_can_see_my_posts who_can_post_timeline who_can_see_others_posts]
  PROFILE_VALUES = %w[public my_community management_only]
  PROFILE_VALUES_MAP = {
    who_can_see_your_name: PROFILE_VALUES,
     who_can_see_your_email: PROFILE_VALUES,
    who_can_see_my_profile: PROFILE_VALUES, 
    who_can_see_my_posts: %w[my_community],
    who_can_post_timeline: PROFILE_VALUES, 
    who_can_see_others_posts: PROFILE_VALUES
  }

  NOTIFICATIONS_RESIDENT = %w[email_when_message email_when_reply_my_comment email_when_write_on_profile email_when_new_poll email_when_new_event
    email_when_new_classified email_when_new_service_request email_when_new_reservation notification_mail_signature
  ]
  NOTIFICATIONS_ADMIN = ['email_when_new_join_request'] + NOTIFICATIONS_RESIDENT
  NOTIFICATIONS_VALUES = %w[yes no]

  def setting_values_for(name)
    if PROFILE.include? name
      PROFILE_VALUES_MAP[name.to_sym]
    elsif NOTIFICATIONS_ADMIN.include? name
      NOTIFICATIONS_VALUES
    end
  end

  def setting_default_value_for(name)
    #public my_community management_only
    
    if PROFILE.include? name
      case name
      when 'who_can_see_your_name'
        'management_only'
      when 'who_can_see_your_email'
        'management_only'
      when 'who_can_see_my_profile'
        'management_only'
      when 'who_can_see_my_posts'
        'my_community'
      when 'who_can_post_timeline'
        'my_community'
      when 'who_can_see_others_posts'
        'my_community'
      else
        'my_community'
      end
    elsif NOTIFICATIONS_ADMIN.include? name
      'yes'
    end
  end

  def settings_notifications
    if admin? || collaborator?
      NOTIFICATIONS_ADMIN
    else
      NOTIFICATIONS_RESIDENT
    end
  end

  def settings_profile
    PROFILE
  end

end

module SettingableCommunity
  PROFILE_WITHOUT_PUBLIC = %w[
    who_can_comment_posts
    who_can_create_events
    who_can_create_polls
    who_can_send_messages
    who_can_create_offers
  ]

  PROFILE = [
    "who_can_see_contact_information",
    "who_can_post_timeline",
    "who_can_see_others_posts",
    *PROFILE_WITHOUT_PUBLIC,
    "who_can_review",
  ]

  PROFILE_VALUES = %w[public community_members management_only]

  NOTIFICATIONS = %w[email_when_post_timeline email_when_post_timeline_reply email_when_review email_when_review_reply append_message_to_outgoing_notifications]
  NOTIFICATIONS_VALUES = %w[yes no]

  DEFAULTS = {
    who_can_see_contact_information: 'public',
    who_can_post_timeline: 'community_members',
    who_can_see_others_posts: 'community_members',
    who_can_comment_posts: 'community_members',
    who_can_create_events: 'community_members',
    who_can_create_polls: 'management_only',
    who_can_send_messages: 'community_members',
    who_can_create_offers: 'community_members',
    who_can_review: 'community_members'
  }

  def setting_values_for(setting_name)
    if PROFILE.include? setting_name
      PROFILE_WITHOUT_PUBLIC.include?(setting_name) ? PROFILE_VALUES - ["public"] : PROFILE_VALUES
    elsif NOTIFICATIONS.include? setting_name
      NOTIFICATIONS_VALUES
    end
  end

  def setting_default_value_for(name)
    if PROFILE.include? name
      DEFAULTS[name.to_sym]
    elsif NOTIFICATIONS.include? name
      'yes'
    end
  end

  def settings_notifications
    NOTIFICATIONS
  end

  def settings_profile
    self.is_a?(Building) ? PROFILE : PROFILE - PROFILE_WITHOUT_PUBLIC
  end

  def notify_new_reply(comment)
    UserMailer.new_comment_reply(comment, email).deliver_later if setting_for('email_when_post_timeline_reply') == 'yes'
  end

  def can_see_by_setting?(setting, user)
    setting_for(setting) == 'public' || (administrators_and_residents.ids.include?(user.id) && setting_for(setting) == 'community_members')
  end

end