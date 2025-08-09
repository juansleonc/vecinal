# Account exists with either this custom domain or subdomain
class WwwOnly
  def self.matches?(request)
    request.subdomains.first == "www"
  end
end

class ValidBuilding
  def self.matches?(request)
    subdomain = request.subdomains.first
    subdomain.present? && subdomain != "www" && Building.find_by_subdomain(subdomain).present?
  end
end

Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks', 
    registrations: 'custom_devise/registrations', 
    confirmations: "custom_devise/confirmations" 
  }

  

  devise_scope :user do
    get 'users/need_help' => 'devise/passwords#new', as: :need_help
    get 'users/create_users' => 'custom_devise/registrations#create_users', as: :create_users
    get 'users/search' => 'custom_devise/registrations#search', as: :search_users
    get 'users/guests' => 'custom_devise/registrations#guests_users'
    get 'users/resend_confirmation_mail' => 'custom_devise/confirmations#resend_confirmation_mail', as: :resend_confirmation_mail
    
  end
  get 'users/delete_users' => 'users#delete_users', as: :delete_users
  patch 'users/:id/update_logo' => 'users#update_logo', as: :update_logo_user
  post 'users/finish_tour' => 'users#finish_tour'
  get 'users/wait_for_acceptance' => 'users#wait_for_acceptance', as: :users_wait_for_acceptance
  post 'users/create_report_software_problem', as: :users_create_report_software_problem
  get 'users/report_software_problem', as: :users_report_software_problem
  get 'users/accountable_code_selection'
  get 'users/export', as: :users_export
  
  get 'users/social_login' => 'pages#social_login', as: :social_login

  # these routes for profile user
  get 'users/profile_banner/:id', to: 'users#profile_banner', as: :user_profile_banner
  get 'users/profile/:id', to: 'users#profile', as: :user_profile
  get 'users/about/:id', to: 'users#about', as: :user_about
  get 'users/photos/:id', to: 'users#photos', as: :user_photos
  get 'users/settings/:id', to: 'users#settings', as: :user_settings
  get 'users/set_password', to: 'users#set_password', as: :set_password
  get 'users/change_password', to: 'users#change_password', as: :change_password
  
  patch 'users/:id', to: 'users#update_profile', as: :user
  post 'users/update_settings/:id', to: 'users#update_settings', as: :user_update_settings
  patch 'users/update_password/:id', to: 'users#update_password', as: :user_update_password
  patch 'users/leave_community/:id', to: 'users#leave_community', as: :user_leave_community
  get 'users/:id/toggle_report', to: 'users#toggle_report', as: :toggle_report_user
  namespace :finish_registration do
    put :set_role
    post :create_community
    get :cancel
    post :send_property_mamager_invitation
    get :buildings
    get :companies
    get :search_buildings
    get :search_companies
  end

  scope controller: :residents do
    get :contacts
    get :search_contacts
    get :communities
    get :news_feed
    get :search_news_feed
    get :reported_contacts
  end

  concern :reportable_hideable do
    member do
      get :toggle_report
      get :toggle_hide
    end
  end
  post 'comments/load_timeline_comment', to: 'comments#load_timeline_comment', as: :load_timeline_comment
  resources :comments, only: [:create, :destroy], concerns: :reportable_hideable
  

  resources :messages, only: [:index, :new, :create, :destroy] do
    collection do
      get :search
      get :receivers
    end
  end
  # get 'messages/selection_changed_user', as: :messages_selection_changed_users
  # get 'messages/selection_changed_building', as: :messages_selection_changed_buildings
  # get 'messages/selection_changed_company', as: :messages_selection_changed_companies
  get 'messages/mark_as_read/:id', to: 'messages#mark_as_read', as: :messages_mark_as_read
  get 'messages/mark_as_unread/:id', to: 'messages#mark_as_unread', as: :messages_mark_as_unread
  get 'messages/mark_as_deleted/:id', to: 'messages#mark_as_deleted', as: :messages_mark_as_deleted
  get 'messages/mark_as_destroyed/:id', to: 'messages#mark_as_destroyed', as: :messages_mark_as_destroyed
  get 'messages/mark_as_done/:id', to: 'messages#mark_as_done', as: :messages_mark_as_done
  get 'messages/move_to_inbox/:id', to: 'messages#move_to_inbox', as: :messages_move_to_inbox
  get 'messages/notify_email_read/:message_id/:user_id' => 'messages#notify_email_read', as: :messages_notify_email_read
  get 'messages/empty_trash' => 'messages#empty_trash', as: :messages_empty_trash
  # get 'contacts' => 'residents#contacts', as: :contacts
  # get 'contacts/search', to: 'residents#search_contacts', as: :search_contacts
  get 'messages/trash', as: :messages_trash
  get 'messages/done', as: :messages_done
  resources :service_requests, only: [:index, :create, :destroy] do
    member do
      get :mark_as_read
      get :change_status
      get :change_responsible
      get :rank
    end
    collection do
      get :export
      get :closed
      get :search
      get :selectable_publishers
    end
  end

  resources :events, only: [:index, :create, :destroy] do
    collection do
      get :past
      get :search
      get :receivers
    end
    member do
      get :toggle_save
      get :toggle_hide
      get :toggle_report
    end
  end
  # get 'events/selection_changed_user', as: :events_selection_changed_users
  # get 'events/selection_changed_building', as: :events_selection_changed_buildings
  # get 'events/selection_changed_company', as: :events_selection_changed_companies
  get 'events/mark_as_acknowledged', as: :events_mark_as_acknowledged
  get 'events/mark_as_yes', as: :events_mark_as_yes
  get 'events/mark_as_no', as: :events_mark_as_no
  get 'events/mark_as_maybe', as: :events_mark_as_maybe
  get 'events/calendar', as: :events_calendar

  # Coupon redemptions
  resources :coupons, only: [] do
    get 'coupon_redemptions' => 'coupon_redemptions#index', as: :redemptions
    get 'coupon_redemptions/print' => 'coupon_redemptions#print', as: :redemption_print
  end
  resources :coupon_redemptions, only: :show do
    member do
      get :redeem
      get :unredeem
    end
  end

  # Deal purchases
  resources :deals, only: [] do
    get 'deal_purchases' => 'deal_purchases#index', as: :purchases
    get 'deal_purchases/pay' => 'deal_purchases#pay', as: :purchase_pay
    post 'deal_purchases' => 'deal_purchases#create'
  end
  get 'deal_purchases/:id/show' => 'deal_purchases#show', as: :deal_purchase
  get 'deal_purchases/:id/redeem' => 'deal_purchases#redeem', as: :deal_purchase_redeem
  get 'deal_purchases/:id/unredeem' => 'deal_purchases#unredeem', as: :deal_purchase_unredeem

  resources :invites, only: [:create, :destroy] do
    get :search_sent, on: :collection
    member do
      get :accept_by_user
      get :resend
    end
  end
  # get 'invites/selection_changed_admin', as: :invites_selection_changed_admin
  # get 'invites/selection_changed_resident', as: :invites_selection_changed_resident

  constraints WwwOnly do
    mount RailsAdmin::Engine => '/superuser', as: 'rails_admin'
    devise_for :admin_users

    resources :businesses, only: [:edit, :update], param: :namespace do
      get 'welcome', as: :welcome
      resources :deals
      resources :coupons
      get 'stripe_connect/(*path)' => 'businesses#stripe_connect', as: :stripe_connect
      get 'stripe_subscription' => 'businesses#stripe_subscription', as: :stripe_subscription
      patch 'stripe_subscriptions' => 'businesses#save_stripe_subscription', as: :save_subscription
      get 'stripe_invoices' => 'businesses#list_invoices', as: :stripe_invoices
      get 'batch_redeem' => 'businesses#batch_redeem', as: :batch_redeem
      get 'reports' => 'businesses#reports', as: :reports
      get 'payments' => 'businesses#payments', as: :payments
      patch 'update_logo', on: :member
    end
    get 'businesses/stripe_response/(*path)' => 'businesses#stripe_response', as: :business_stripe_response

    # Company pages
    resources :companies, only: [:edit, :update, :destroy], param: :namespace do
      # get 'news_feed', as: :news_feed
      get 'invites_sent', as: :invites_sent
      get 'invites_received', as: :invites_received
      post 'accept_user', as: :accept_user
      post 'reject_user', as: :reject_user
      post 'reject_accepted_user', as: :reject_accepted_user
      get 'stripe_subscription' => 'companies#stripe_subscription', as: :stripe_subscription
      get 'stripe_plans' => 'companies#stripe_plans', as: :stripe_plans
      patch 'stripe_subscriptions' => 'companies#save_stripe_subscription', as: :save_subscription
      get 'stripe_invoices' => 'companies#list_invoices', as: :stripe_invoices
      # get :search_news_feed
      member do
        get :search_invites_received
        patch :update_logo
        post :update_settings
      end
      resources :buildings, except: :destroy, param: :building_subdomain
      resources :apartments
      resources :users, only: [:index, :edit, :update]
    end

    devise_scope :user do
      get 'companies/:namespace/users/sign_up' => 'custom_devise/registrations#new', as: :company_sign_up
    end

    # Public pages
    get 'companies/:namespace/buildings_search' => 'buildings#search', as: :building_search
    get 'companies/:namespace/about' => 'pages#company_about', as: :company_public_about
    get 'companies/:namespace/photos' => 'pages#company_photos', as: :company_public_photos
    get 'companies/:namespace/communities' => 'pages#company_communities', as: :company_public_communities
    get 'companies/:namespace/reviews' => 'pages#company_reviews', as: :company_public_reviews
    get 'companies/:namespace/settings' => 'pages#company_settings', as: :company_public_settings
    get 'companies/:namespace', to: 'pages#company', as: :company_root

  end

  constraints ValidBuilding do
    get 'about' => 'pages#building_about', as: :building_about
    get 'reviews' => 'pages#building_reviews', as: :building_reviews
    get 'photos' => 'pages#building_photos', as: :building_photos
    get 'settings' => 'pages#building_settings', as: :building_settings
    scope '/companies/:company_namespace/buildings/:building_subdomain' do
      patch :update_logo, to: 'buildings#update_logo', as: :update_logo_building
      post :update_settings, to: 'buildings#update_settings', as: :update_settings_building
      delete '', to: 'buildings#destroy', as: :building
    end

    # Promotions
    get 'deals' => 'deals#resident_index', as: :resident_deals
    get 'businesses/:namespace/deals/:id' => 'deals#show', as: :resident_business_deal
    get 'businesses/:namespace/deals/:id/add_click' => 'deals#add_click', as: :resident_business_deal_add_click
    get 'coupons' => 'coupons#resident_index', as: :resident_coupons
    get 'businesses/:namespace/coupons/:id' => 'coupons#show', as: :resident_business_coupon
    get 'businesses/:namespace/coupons/:id/add_click' => 'coupons#add_click', as: :resident_business_coupon_add_click
    get 'businesses/nearby' => 'businesses#nearby', as: :businesses_nearby
    get 'my_stuff' => 'users#my_stuff', as: :my_stuff

    # Authenticated pages:
    #get 'dashboard' => 'residents#dashboard', as: :resident_dashboard
    # get 'communities', to: 'residents#communities', as: :resident_communities
    # get :search_news_feed, to: 'residents#search_news_feed', as: :resident_search_news_feed

    root 'pages#building', as: :building_root
  end

  get 'businesses/:namespace', to: 'pages#business', as: :business_root
  get 'businesses/:namespace/about' => 'pages#business_about', as: :business_public_about
  get 'businesses/:namespace/photos' => 'pages#business_photos', as: :business_public_photos
  get 'businesses/:namespace/offers' => 'pages#business_offers', as: :business_public_offers
  get 'businesses/:namespace/reviews' => 'pages#business_reviews', as: :business_public_reviews
  # get 'businesses/:namespace/contact' => 'pages#business_contact', as: :business_public_contact
  # post 'businesses/:namespace/contact' => 'pages#business_contact_send', as: :business_public_contact_send
  # get 'businesses/:namespace/coupons/:id/add_click' => 'coupons#add_click', as: :business_coupon_add_click
  # get 'businesses/:namespace/deals/:id/add_click' => 'deals#add_click', as: :business_deal_add_click

  get 'welcome' => 'pages#welcome', as: :welcome
  get 'change_language' => 'pages#change_language', as: :change_language

  localized do
    get 'privacy' => 'pages#privacy'
    get 'terms' => 'pages#terms'
  end

  get 'merchant_agreement' => 'pages#merchant_agreement'

  resources :folders, only: [:index, :show, :create, :destroy, :update] do
    get :search, on: :collection
  end
  post 'folders/:id/add_attachments', to: 'folders#add_attachments', as: :folder_add_attachments
  patch 'folders/:id/update_attachment/:attachment_id', to: 'folders#update_attachment', as: :folder_update_attachment
  delete 'folders/:id/destroy_attachment/:attachment_id', to: 'folders#destroy_attachment', as: :folder_destroy_attachment

  resources :amenities, except: :new do
    member do
      get :reviews
      get :photos
      get :calendar
      get :change_responsible
    end
    get :search, on: :collection
  end

  resources :reservations do
    get :mark_as_read, on: :member
    get :search, on: :collection
    member do
    
      get :change_responsible
    end
  end
  put 'reservations/:id/change_status/:status', to: 'reservations#change_status', as: :reservation_change_status
  post 'get_reservation_schedule',  to: 'reservations#get_schedule'
  post 'get_operating_schedule', to: 'amenities#get_operating_schedule'
  post 'get_limit_time', to: 'amenities#get_limit_time'
  

  resources :polls, only: [:index, :create, :destroy] do
    get :search, on: :collection
    member do
      get :toggle_save
    end
    concerns :reportable_hideable
  end
  get '/polls/filtered/:filter', to: 'polls#index', as: :filtered_polls

  resources :poll_votes, only: [:create, :update]

  resources :reviews, only: [:create, :destroy], concerns: :reportable_hideable

  resources :classifieds, only: [:index, :create, :edit, :update, :destroy] do
    get :search, on: :collection
    member do
      get :toggle_save
    end
    concerns :reportable_hideable
  end
  get '/classifieds/filtered/:filter', to: 'classifieds#index', as: :filtered_classifieds

  resources :payments, only: [:index, :create] do
    get :search, on: :collection
  end

  resources :payment_accounts, only: [:index, :create, :edit, :update]
  get 'payment_accounts/:building_subdomain/new', to: 'payment_accounts#new', as: :new_payment_account

  resources :images, only: %i(create destroy) do
    post :create_multiple, on: :collection
    get :set_as_cover, on: :member
  end

  get 'likes/toggle/:likeable_type/:likeable_id', to: 'likes#toggle', as: :toggle_like

  # Stats dashboard routes
  get :dashboard, to: 'dashboard#index'
  get 'dashboard/update_chart', to: 'dashboard#update_chart_content', as: :update_chart
  get 'dashboard/update_report', to: 'dashboard#update_report', as: :update_report
  get 'dashboard/update_chart_content', to: 'dashboard#update_chart', as: :full_update_chart
  get 'dashboard/print_report', to: 'dashboard#print_report', as: :print_report
  get 'dashboard/print_chart', to: 'dashboard#print_chart', as: :print_chart
  

  resources :account_balances, only: %i(index create)
  resources :user_balances, controller: 'user_balances', path: 'balances', only: %i(index destroy) do
    get 'print', on: :member
    get 'print_all', on: :collection
    
    collection do
      post 'destroy_selected'
      get 'search'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  match '/404', to: 'pages#not_found', via: :all
  match '/500', to: 'pages#internal_error', via: :all

  get 'inbound-emails' => 'inbound_emails#index'
  post 'inbound-emails' => 'inbound_emails#index', as: :InboundEmails
  # You can have the root of your site routed with "root"
  root 'pages#index', as: :root
  #post '/email_processor' => 'griddler/emails#create'
  mount_griddler
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
