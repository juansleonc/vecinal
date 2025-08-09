class Ability
  include CanCan::Ability

  def initialize(user, ip_address=nil)

    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, Company, id: user.accountable_id
      cannot :destroy, Company
      can :destroy, Company, owner: user

      can :manage, Building, company_id: user.accountable_id
      can :manage, Apartment, building: { company_id: user.accountable_id }

      # Comments
      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'Event', commentable_id: EventsUsers.where(['user_id = ?', user.id]).pluck(:event_id)
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user.contacts << user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: user.accountable.reservations.ids

      can :destroy, Comment, commentable_type: 'User', commentable_id: user.contacts.ids + [user.id]
      can :destroy, Comment, commentable_type: 'Building', commentable_id: user.accountable.buildings.pluck(:id)
      can :destroy, Comment, commentable_type: 'Company', commentable_id: user.accountable_id

      # Messages
      can :manage, Message, sender_id: user.id
      can :manage, Message, id: user.messages.ids

      # Service Requests
      can :manage, ServiceRequest, responsible_id: user.accountable.id, responsible_type: 'Company'
      can :manage, ServiceRequest, responsible_id: user.company_contacts.ids, responsible_type: 'User'
      can :rank, ServiceRequest, status: 'closed', publisher: user
      
      can [:change_responsible, :select_publisher] , ServiceRequest
      cannot :change_responsible, ServiceRequest, status: 'closed'

      can :manage, Event, sender_id: user.id
      can :manage, Event, id: user.events.ids
      cannot :comment, Event, sender: user

      # Users
      can :manage, User, id: user.contacts.ids + [user.id]
      can :create_user, User
      cannot :expel, User, id: user.id
      cannot :leave_community, User, id: user.accountable.user_id
      cannot [:roles, :communities, :set_role, :settings], User
      can :settings, User, id: user.id
      
      cannot :toggle_report, User

      can :manage, Invite, inviter_id: user.accountable.admins.ids

      can :manage, Folder, folderable_type: 'Company', folderable_id: user.accountable.id
      can :manage, Folder, folderable_type: 'Building', folderable_id: user.accountable.buildings.ids

      can :manage, Amenity, building_id: user.accountable.buildings.ids
      can :manage, Reservation, amenity: { building_id: user.accountable.buildings.ids }

      can :manage, Poll, publisher: user
      can :manage, Poll, id: user.shared_with_my_community_ids(Poll)
      can [:search, :read], Poll, id: Poll.shared_public.ids

      can :manage, Review, user: user
      can :manage, Review, reviewable_type: 'Amenity', reviewable: { building_id: user.accountable.buildings.ids }
      can :manage, Review, reviewable_type: 'Company', reviewable_id: user.accountable.id
      can :manage, Review, reviewable_type: 'Building', reviewable_id: user.accountable.buildings.ids

      can :manage, Classified
      can :manage, Classified, id: user.shared_with_my_community_ids(Classified)
      can [:search, :read], Classified, id: Classified.shared_public.ids

      can [:toggle_save, :toggle_hide], [Classified, Poll, Review, Comment, Event]
      cannot :toggle_report, [Classified, Poll, Review, Comment, Event]

      # Account Balances
      can :create, AccountBalance
      can :destroy_all, AccountBalance, user_id: user.id

      # User Balances
      can %i(index destroy print print_all destroy_selected search), UserBalance, account_balance: { user_id: user.company_contacts.ids }

      # Contact Details
      can :update_apartment_numbers, ContactDetails
      can :update_apartment_numbers, ContactDetails, user_id: user.id

    elsif user.collaborator?
      can :manage, Company, id: user.accountable_id
      #cannot [:]
      cannot :destroy, Company
      can :destroy, Company, owner: user

      can :read, Building, company_id: user.accountable_id
      can :read, Apartment, building: { company_id: user.accountable_id }

      # Comments
      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'Event', commentable_id: EventsUsers.where(['user_id = ?', user.id]).pluck(:event_id)
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user.contacts << user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: user.accountable.reservations.ids

      can :destroy, Comment, commentable_type: 'User', commentable_id: user.contacts.ids + [user.id]
      can :destroy, Comment, commentable_type: 'Building', commentable_id: user.accountable.buildings.pluck(:id)
      can :destroy, Comment, commentable_type: 'Company', commentable_id: user.accountable_id

      # Messages
      can :manage, Message, sender_id: user.id
      can :manage, Message, id: user.messages.ids

      # Service Requests
      can :manage, ServiceRequest, responsible_id: user.accountable.id, responsible_type: 'Company'
      can :manage, ServiceRequest, responsible_id: user.company_contacts.ids, responsible_type: 'User'
      can :rank, ServiceRequest, status: 'closed', publisher: user
      
      can [:change_responsible, :select_publisher] , ServiceRequest
      cannot :change_responsible, ServiceRequest, status: 'closed'

      can :manage, Event, sender_id: user.id
      can :manage, Event, id: user.events.ids
      cannot :comment, Event, sender: user

      # Users
      can :manage, User, id: user.contacts.ids + [user.id]
      cannot :expel, User, id: user.id
      cannot :create_user, User
      cannot :leave_community, User, id: user.accountable.user_id
      cannot [:roles, :communities, :set_role, :settings, :create, :destroy], User
      can :settings, User, id: user.id
      cannot :toggle_report, User

      #cannot :manage, Invite, inviter_id: user.accountable.admins.ids

      can :manage, Folder, folderable_type: 'Company', folderable_id: user.accountable.id
      can :manage, Folder, folderable_type: 'Building', folderable_id: user.accountable.buildings.ids

      can :manage, Amenity, building: user.accountable.buildings.to_a
      can :manage, Reservation, amenity: { building_id: user.accountable.buildings.ids }

      can :manage, Poll, publisher: user
      can :manage, Poll, id: user.shared_with_my_community_ids(Poll)
      can [:search, :read], Poll, id: Poll.shared_public.ids

      can :manage, Review, user: user
      can :manage, Review, reviewable_type: 'Amenity', reviewable: { building_id: user.accountable.buildings.ids }
      can :manage, Review, reviewable_type: 'Company', reviewable_id: user.accountable.id
      can :manage, Review, reviewable_type: 'Building', reviewable_id: user.accountable.buildings.ids

      can :manage, Classified, publisher: user
      can :manage, Classified, id: user.shared_with_my_community_ids(Classified)
      can [:search, :read], Classified, id: Classified.shared_public.ids

      can [:toggle_save, :toggle_hide], [Classified, Poll, Review, Comment, Event]
      cannot :toggle_report, [Classified, Poll, Review, Comment, Event]

      # Account Balances
      can :create, AccountBalance
      can :destroy_all, AccountBalance, user_id: user.id

      # User Balances
      can %i(index destroy print print_all destroy_selected search), UserBalance, account_balance: { user_id: user.company_contacts.ids }

      # Contact Details
      can :update_apartment_numbers, ContactDetails
      can :update_apartment_numbers, ContactDetails, user_id: user.id


    elsif user.resident?
      # Comments
      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'Event', commentable_id: EventsUsers.where(['user_id = ?', user.id]).pluck(:event_id)
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: user.reservations.ids

      can :destroy, Comment, user_id: user.id

      # Messages
      can [:read, :mark_as_deleted, :selection_changed_user, :selection_changed_company, :selection_changed_building, :trash, :done, :search], Message, sender_id: user.id
      can [:read, :mark_as_read, :mark_as_unread, :mark_as_deleted, :mark_as_done, :empty_trash, :mark_as_destroyed, :move_to_inbox, :trash, :done, :search, :receivers], Message, id: user.messages.ids
      can :create, Message if user.can_do_by_setting? "who_can_send_messages"

      # Service Requests
      can [:read, :create, :update, :mark_as_read, :closed, :search], ServiceRequest, user: user
      can [:change_status, :rank], ServiceRequest, status: 'closed', publisher: user

      # Events
      can :destroy, Event, sender_id: user.id
      can :create, Event if user.can_do_by_setting? "who_can_create_events"
      can [:read, :mark_as_acknowledged, :mark_as_yes, :mark_as_no, :mark_as_maybe, :selection_changed_user, :selection_changed_company, :selection_changed_building, :calendar, :past, :receivers], Event, id: user.events.ids

      # Users
      can :manage, User, id: user.id
      
      cannot [:roles, :communities, :set_role, :create_user], User
      can :toggle_report, User
      cannot :toggle_report, User, id: user.id

      # Promotions
      can [:read, :nearby], Business
      can [:resident_index, :show, :add_click], Deal
      can [:resident_index, :show, :add_click], Coupon
      can [:show, :print], CouponRedemption, user_id: user.id
      can [:pay, :create, :show], DealPurchase, user_id: user.id

      can [:read, :search], Folder, folderable_type: 'Building', folderable_id: user.accountable.id

      can [:read, :get_operating_schedule, :get_limit_time, :calendar], Amenity, building: user.accountable

      can [:read, :create, :comment, :mark_as_read, :get_schedule], Reservation, reserver: user, amenity: { building_id: user.accountable_id }
      can [:read, :search], Reservation, amenity: { building_id: user.accountable_id }

      can %i(index destroy), publisher: user
      can [:read, :search], Poll, id: user.shared_with_my_community_ids(Poll)
      can [:read, :search], Poll, id: Poll.shared_public.ids
      can :create, Poll if user.can_do_by_setting? "who_can_create_polls"

      # Reviews
      can :manage, Review, user: user
      can :read, Review, reviewable_type: 'Building', reviewable_id: user.accountable.id
      can [:reviews, :review], Amenity, building_id: user.accountable.id

      can %i(index edit update destroy), Classified, publisher: user
      can [:read, :search], Classified, id: user.shared_with_my_community_ids(Classified)
      can [:read, :search], Classified, id: Classified.shared_public.ids
      can :create, Classified if user.can_do_by_setting? "who_can_create_offers"

      can [:toggle_save, :toggle_report, :toggle_hide], [Classified, Poll, Review, Comment, Event]
      cannot :toggle_report, [Classified, Poll, Review, Comment, Event], publisher: user

      # Contact Details
      cannot :update_apartment_number, ContactDetails

      # User Balances
      can %i(index print print_all search), UserBalance, apartment_number: user.contact_details.apartment_numbers

    elsif user.board_member?
      # Comments
      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'Event', commentable_id: EventsUsers.where(['user_id = ?', user.id]).pluck(:event_id)
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: user.reservations.ids

      can :destroy, Comment, user_id: user.id

      # Messages
      can [:read, :mark_as_deleted, :selection_changed_user, :selection_changed_company, :selection_changed_building, :trash, :done, :search], Message, sender_id: user.id
      can [:read, :mark_as_read, :mark_as_unread, :mark_as_deleted, :mark_as_done, :empty_trash, :mark_as_destroyed, :move_to_inbox, :trash, :done, :search, :receivers], Message, id: user.messages.ids
      can :create, Message if user.can_do_by_setting? "who_can_send_messages"

      # Service Requests
      can [:read,  :search], ServiceRequest, user_id: user.company_contacts.ids
      can [:change_status, :rank], ServiceRequest, status: 'closed', publisher: user
      can [:read, :create, :update, :mark_as_read, :closed, :search], ServiceRequest, user: user
      
      can :rank, ServiceRequest, status: 'closed', publisher: user
      
      can [:change_responsible, :select_publisher] , ServiceRequest
      cannot :change_responsible, ServiceRequest, status: 'closed'

      can :manage, Event, sender_id: user.id
      can :manage, Event, id: user.events.ids
      cannot :comment, Event, sender: user

      # Events
      can :destroy, Event, sender_id: user.id
      can :create, Event if user.can_do_by_setting? "who_can_create_events"
      can [:read, :mark_as_acknowledged, :mark_as_yes, :mark_as_no, :mark_as_maybe, :selection_changed_user, :selection_changed_company, :selection_changed_building, :calendar, :past, :receivers], Event, id: user.events.ids

      # Users
      can :manage, User, id: user.id
      
      cannot [:roles, :communities, :set_role, :create_user], User
      can :toggle_report, User
      cannot :toggle_report, User, id: user.id

      # Promotions
      can [:read, :nearby], Business
      can [:resident_index, :show, :add_click], Deal
      can [:resident_index, :show, :add_click], Coupon
      can [:show, :print], CouponRedemption, user_id: user.id
      can [:pay, :create, :show], DealPurchase, user_id: user.id

      can [:read, :search], Folder, folderable_type: 'Building', folderable_id: user.accountable.id

      can [:read, :get_operating_schedule, :get_limit_time, :calendar], Amenity, building: user.accountable

      can [:read, :create, :comment, :mark_as_read, :get_schedule], Reservation, reserver: user, amenity: { building_id: user.accountable_id }
      can [:read, :search], Reservation, amenity: { building_id: user.accountable_id }

      can %i(index destroy), publisher: user
      can [:read, :search], Poll, id: user.shared_with_my_community_ids(Poll)
      can [:read, :search], Poll, id: Poll.shared_public.ids
      can :create, Poll if user.can_do_by_setting? "who_can_create_polls"

      # Reviews
      can :manage, Review, user: user
      can :read, Review, reviewable_type: 'Building', reviewable_id: user.accountable.id
      can [:reviews, :review], Amenity, building_id: user.accountable.id

      can %i(index edit update destroy), Classified, publisher: user
      can [:read, :search], Classified, id: user.shared_with_my_community_ids(Classified)
      can [:read, :search], Classified, id: Classified.shared_public.ids
      can :create, Classified if user.can_do_by_setting? "who_can_create_offers"

      can [:toggle_save, :toggle_report, :toggle_hide], [Classified, Poll, Review, Comment, Event]
      cannot :toggle_report, [Classified, Poll, Review, Comment, Event], publisher: user

      # Contact Details
      cannot :update_apartment_number, ContactDetails

      # User Balances
      can %i(index print print_all search), UserBalance, apartment_number: user.contact_details.apartment_numbers

    elsif user.tenant?
      # Comments
      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'Event', commentable_id: EventsUsers.where(['user_id = ?', user.id]).pluck(:event_id)
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: user.reservations.ids

      can :destroy, Comment, user_id: user.id

      # Messages
      can [:read, :mark_as_deleted, :selection_changed_user, :selection_changed_company, :selection_changed_building, :trash, :done, :search], Message, sender_id: user.id
      can [:read, :mark_as_read, :mark_as_unread, :mark_as_deleted, :mark_as_done, :empty_trash, :mark_as_destroyed, :move_to_inbox, :trash, :done, :search, :receivers], Message, id: user.messages.ids
      can :create, Message if user.can_do_by_setting? "who_can_send_messages"

      # Service Requests
      can [:read, :create, :update, :mark_as_read, :closed, :search], ServiceRequest, user: user
      can [:change_status, :rank], ServiceRequest, status: 'closed', publisher: user

      # Events
      can :destroy, Event, sender_id: user.id
      can :create, Event if user.can_do_by_setting? "who_can_create_events"
      can [:read, :mark_as_acknowledged, :mark_as_yes, :mark_as_no, :mark_as_maybe, :selection_changed_user, :selection_changed_company, :selection_changed_building, :calendar, :past, :receivers], Event, id: user.events.ids

      # Users
      can :manage, User, id: user.id
      
      cannot [:roles, :communities, :set_role, :create_user], User
      can :toggle_report, User
      cannot :toggle_report, User, id: user.id

      # Promotions
      can [:read, :nearby], Business
      can [:resident_index, :show, :add_click], Deal
      can [:resident_index, :show, :add_click], Coupon
      can [:show, :print], CouponRedemption, user_id: user.id
      can [:pay, :create, :show], DealPurchase, user_id: user.id

      can [:read, :search], Folder, folderable_type: 'Building', folderable_id: user.accountable.id

      can [:read, :get_operating_schedule, :get_limit_time, :calendar], Amenity, building: user.accountable

      can [:read, :create, :comment, :mark_as_read, :get_schedule], Reservation, reserver: user, amenity: { building_id: user.accountable_id }
      can [:read, :search], Reservation, amenity: { building_id: user.accountable_id }

      can %i(index destroy), publisher: user
      can [:read, :search], Poll, id: user.shared_with_my_community_ids(Poll)
      can [:read, :search], Poll, id: Poll.shared_public.ids
      can :create, Poll if user.can_do_by_setting? "who_can_create_polls"

      # Reviews
      can :manage, Review, user: user
      can :read, Review, reviewable_type: 'Building', reviewable_id: user.accountable.id
      can [:reviews, :review], Amenity, building_id: user.accountable.id

      can %i(index edit update destroy), Classified, publisher: user
      can [:read, :search], Classified, id: user.shared_with_my_community_ids(Classified)
      can [:read, :search], Classified, id: Classified.shared_public.ids
      can :create, Classified if user.can_do_by_setting? "who_can_create_offers"

      can [:toggle_save, :toggle_report, :toggle_hide], [Classified, Poll, Review, Comment, Event]
      cannot :toggle_report, [Classified, Poll, Review, Comment, Event], publisher: user

      # Contact Details
      cannot :update_apartment_number, ContactDetails

      # User Balances
      can %i(index print print_all search), UserBalance, apartment_number: user.contact_details.apartment_numbers

    elsif user.agent?
      # Comments
      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'Event', commentable_id: EventsUsers.where(['user_id = ?', user.id]).pluck(:event_id)
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: user.reservations.ids

      can :destroy, Comment, user_id: user.id

      # Messages
      can [:read, :mark_as_deleted, :selection_changed_user, :selection_changed_company, :selection_changed_building, :trash, :done, :search], Message, sender_id: user.id
      can [:read, :mark_as_read, :mark_as_unread, :mark_as_deleted, :mark_as_done, :empty_trash, :mark_as_destroyed, :move_to_inbox, :trash, :done, :search, :receivers], Message, id: user.messages.ids
      can :create, Message if user.can_do_by_setting? "who_can_send_messages"

      # Service Requests
      can [:read, :create, :update, :mark_as_read, :closed, :search], ServiceRequest, user: user
      can [:change_status, :rank], ServiceRequest, status: 'closed', publisher: user

     

      can :manage, Event, sender_id: user.id
      can :manage, Event, id: user.events.ids
      cannot :comment, Event, sender: user

      # Events
      can :destroy, Event, sender_id: user.id
      can :create, Event if user.can_do_by_setting? "who_can_create_events"
      can [:read, :mark_as_acknowledged, :mark_as_yes, :mark_as_no, :mark_as_maybe, :selection_changed_user, :selection_changed_company, :selection_changed_building, :calendar, :past, :receivers], Event, id: user.events.ids

      # Users
      can :manage, User, id: user.id
      
      cannot [:roles, :communities, :set_role, :create_user], User
      can :toggle_report, User
      cannot :toggle_report, User, id: user.id

      # Promotions
      can [:read, :nearby], Business
      can [:resident_index, :show, :add_click], Deal
      can [:resident_index, :show, :add_click], Coupon
      can [:show, :print], CouponRedemption, user_id: user.id
      can [:pay, :create, :show], DealPurchase, user_id: user.id

      can [:read, :search], Folder, folderable_type: 'Building', folderable_id: user.accountable.id

      can [:read, :get_operating_schedule, :get_limit_time, :calendar], Amenity, building: user.accountable

      can [:read, :create, :comment, :mark_as_read, :get_schedule], Reservation, reserver: user, amenity: { building_id: user.accountable_id }
      can [:read, :search], Reservation, amenity: { building_id: user.accountable_id }

      can %i(index destroy), publisher: user
      can [:read, :search], Poll, id: user.shared_with_my_community_ids(Poll)
      can [:read, :search], Poll, id: Poll.shared_public.ids
      can :create, Poll if user.can_do_by_setting? "who_can_create_polls"

      # Reviews
      can :manage, Review, user: user
      can :read, Review, reviewable_type: 'Building', reviewable_id: user.accountable.id
      can [:reviews, :review], Amenity, building_id: user.accountable.id

      can %i(index edit update destroy), Classified, publisher: user
      can [:read, :search], Classified, id: user.shared_with_my_community_ids(Classified)
      can [:read, :search], Classified, id: Classified.shared_public.ids
      can :create, Classified if user.can_do_by_setting? "who_can_create_offers"

      can [:toggle_save, :toggle_report, :toggle_hide], [Classified, Poll, Review, Comment, Event]
      cannot :toggle_report, [Classified, Poll, Review, Comment, Event], publisher: user

      # Contact Details
      cannot :update_apartment_number, ContactDetails

      # User Balances
      can %i(index print print_all search), UserBalance, apartment_number: user.contact_details.apartment_numbers


    elsif user.supplier?
      can :manage, Business, id: user.accountable_id

      # Users
      can [:read, :update, :report_software_problem], User, id: user.id
      cannot [:roles, :communities, :set_role], User

      # Promotions
      can :manage, Deal, business_id: user.accountable_id
      can :manage, Coupon, business_id: user.accountable_id
      can :manage, CouponRedemption, coupon: { business_id: user.accountable_id }
      can :manage, DealPurchase, deal: { business_id: user.accountable_id }
    else
      # For users without community
      can :manage, User, id: user.id
      can [:read, :mark_as_read, :mark_as_unread, :mark_as_deleted, :mark_as_done, :empty_trash, :mark_as_destroyed, :move_to_inbox, :trash, :done, :search], Message, sender_id: user.id
      can [:read, :mark_as_read, :mark_as_unread, :mark_as_deleted, :mark_as_done, :empty_trash, :mark_as_destroyed, :move_to_inbox, :trash, :done, :search], Message, id: user.messages.ids
      can [:read, :mark_as_read, :closed, :search], ServiceRequest, user: user

      can :manage, Poll, publisher: user
      can :search, Poll, id: Poll.shared_public.ids
      can :read, Poll, id: Poll.shared_public.ids, publisher_id: User.near_by_ip(ip_address, Poll::DISTANCE_FOR_PUBLICS).ids

      can :manage, Classified, publisher: user
      can :search, Classified, id: Classified.shared_public.ids
      can :read, Classified, id: Classified.shared_public.ids, publisher_id: User.near_by_ip(ip_address, Classified::DISTANCE_FOR_PUBLICS).ids

      can :create, Comment, commentable_type: 'Message', commentable_id: Message.with_user(user).ids
      can :create, Comment, commentable_type: 'ServiceRequest', commentable_id: ServiceRequest.where(user: user).ids
      can :create, Comment, commentable_type: 'Reservation', commentable_id: Reservation.where(reserver: user).ids
      can [:read, :past], Event, sender: user
      can [:read, :search], Folder, folderable_type: 'Building', folderable_id: user.accountable_id
      can :read, Amenity, id: nil
      can [:read, :comment], Reservation, reserver: user
      can [:read, :nearby], Business
      can :accept_by_user, Invite, email: user.email
      cannot :toggle_report, User, id: user.id
    end

    if user.has_community_and_role? && !user.accepted?
      can [:finish_registration_cancel, :communities], User
    end

    if user.persisted?
      # Users -> Settings
      can [:see_profile_details, :about, :photos], User do |other_user|
        user.can_see_by_setting? 'who_can_see_my_profile', other_user
      end

      can :post_on_timeline, User do |other_user|
        user.can_see_by_setting? 'who_can_post_timeline', other_user
      end

      can :see_profile_posts_from_others, User do |other_user|
        user.can_see_by_setting? 'who_can_see_others_posts', other_user
      end

       # Company
      can :comment, Company do |company|
        company.can_see_by_setting? 'who_can_post_timeline', user
      end
      can :see_contact_information, Company do |company|
        company.can_see_by_setting? 'who_can_see_contact_information', user
      end
      can :see_timeline_posts, Company do |company|
        company.can_see_by_setting? 'who_can_see_others_posts', user
      end
      can :review, Company do |company|
        company.can_see_by_setting? 'who_can_review', user
      end

      #Building
      can :comment, Building do |building|
        building.can_see_by_setting? 'who_can_post_timeline', user
      end
      can :see_contact_information, Building do |building|
        building.can_see_by_setting? 'who_can_see_contact_information', user
      end
      can :see_timeline_posts, Building do |building|
        building.can_see_by_setting? 'who_can_see_others_posts', user
      end
      can :review, Building do |building|
        building.can_see_by_setting? 'who_can_review', user
      end

      # Comments
      can :create, Comment, commentable_type: %w[Comment User Company Building Classified Review]
      #Poll Votes
      can [:create, :update], PollVote, poll_id: user.shared_with_me(Poll).ids

      # can [:create, :destroy], Like, user: user
      can :toggle, Like, user: user

      can :post_for_community, Comment if user.can_do_by_setting? "who_can_post_timeline"
      can :comment_posts, Comment if user.can_do_by_setting? "who_can_comment_posts"

      can :change_password , User, id: user.id if user.change_password == true
      #can :change_password, User, id: user.id
    end

    can [:finish_tour, :accountable_code_selection, :report_software_problem, :create_report_software_problem, :profile, :profile_banner], User
    can :notify_email_read, Message
    can :pay, DealPurchase
    can :print, CouponRedemption
    can :add_click, Deal
    can :add_click, Coupon

    can :see_contact_information, Company do |company|
      company.setting_for('who_can_see_contact_information') == 'public'
    end

    can :see_contact_information, Building do |building|
      building.setting_for('who_can_see_contact_information') == 'public'
    end

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
