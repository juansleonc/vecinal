class User < ActiveRecord::Base

  CONTACTS_PER_PAGE = 20
  USERS_PER_PAGE = 20
  # ROLES = %w[administrator resident supplier] Commented until suppliers come be active again
  ROLES = %w[administrator resident board_member tenant agent collaborator]
  ROLE_ICONS = { administrator: 'fa-briefcase',collaborator: 'fa-briefcase', resident: 'fa-building-o', board_member: 'fa-building-o', tenant: 'fa-building-o', agent: 'fa-building-o', supplier: 'fa-shopping-cart' }
  ACCOUTABLE_TYPES = %w[Building Company Business]

  include HasLogo
  include NilModels
  include Settingable
  include SettingableUser
  include Markable
  include Shareable
  include Countable

  # Include default devise modules. Others available are :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, omniauth_providers: %i[facebook linkedin google_oauth2]

  acts_as_reader

  belongs_to :accountable, polymorphic: true
  has_one :business
  has_one :company
  #has_many :collaborators, class_name: 'User', as: :accountable
  has_one :contact_details
  has_many :events_users, class_name: 'EventsUsers', dependent: :destroy
  has_many :events, through: :events_users
  has_many :messages_users, class_name: 'MessagesUsers'
  has_many :messages, through: :messages_users
  has_many :redemptions, class_name: 'CouponRedemption'
  has_many :purchases, class_name: 'DealPurchase'
  has_many :reservations, foreign_key: 'reserver_id'
  has_many :images, as: :imageable
  has_many :comments, as: :commentable
  has_many :payments
  has_many :account_balances
  has_and_belongs_to_many :user_balances

  accepts_nested_attributes_for :contact_details, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  alias_method :old_accountable, :accountable
  attr_accessor :accountable_code, :invite_id

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, inclusion: { in: ROLES, allow_nil: true }
  validates :locale, inclusion: { in: CM_LOCALES }
  validate :accountable_exists

  before_save :set_accountable_id, :set_role_from_accountable
  before_save :check_pending_invites, if: :accountable_assigned?
  before_create :set_from_invite
  before_update :send_update_email, :create_user_details
  after_save :check_for_user_balances, if: :contact_details_present?

  scope :search_by, -> (query) { 
    query_parts = query.split(' ')
    raw_sql = ''
    raw_sql_building = ''
    query_parts.each do |part|
      if raw_sql != ''
        raw_sql += " OR "
        raw_sql_building += " OR "
      end
      raw_sql += " CONCAT(sp_ascii(users.first_name),\' \',sp_ascii(users.last_name)) ILIKE '%" + part + "%' OR users.email ILIKE '%" + part + "%' OR sp_ascii(users.first_name) ILIKE '%" + part + "%' OR sp_ascii(users.last_name) ILIKE '%" + part + "%' OR contact_details.apartment_numbers ILIKE '%" + part + "%' "
      raw_sql_building += " name ILIKE '%" + part + "%' "
    end
    result_building = Building.where(raw_sql_building)
    prepare_sql = distinct.joins('LEFT OUTER JOIN "contact_details" ON "contact_details"."user_id" = "users"."id"').where(raw_sql)
    unless result_building.empty?
      prepare_sql = prepare_sql.where(accountable: result_building)
    end
    return prepare_sql
  }
=begin
  scope :search_by, -> (query) { distinct.joins('LEFT OUTER JOIN "contact_details" ON "contact_details"."user_id" = "users"."id"').where(
  ' CONCAT(sp_ascii(users.first_name),\' \',sp_ascii(users.last_name)) ILIKE :query OR users.email ILIKE :query OR sp_ascii(users.first_name) ILIKE :query OR sp_ascii(users.last_name) ILIKE :query OR contact_details.apartment_numbers ILIKE :query',
  query: "%#{query}%"
  )}
=end
  scope :by, -> (users) { where(id: users) }

  scope :find_by_apartments, -> (community, number) do
    joins(:contact_details).where(accountable: community, contact_details: { apartment_numbers: number })
  end

  after_initialize do |user|
    if user.admin?
      user.extend UserUtils::Admin
    elsif user.resident?
      user.extend UserUtils::Resident
    elsif user.supplier?
      user.extend UserUtils::Supplier
    elsif user.board_member?
      user.extend UserUtils::BoardMember
    elsif user.tenant?
      user.extend UserUtils::Tenant
    elsif user.agent?
      user.extend UserUtils::Agent
    elsif user.collaborator?
      user.extend UserUtils::Collaborator
    else
      user.extend UserUtils::NoRole
    end
  end

  # Returns a users array
  def self.with_apartment community, apartment_number
    user_array = where(accountable: community).select { |user| user.contact_details.apartment_numbers.include? apartment_number }
  end

  def admin?
    member? && accountable_type == 'Company' && role == 'administrator'
  end

  def resident?
    member? && accountable_type == 'Building' && role == 'resident'
  end

  def supplier?
    member? && accountable_type == 'Business' && role == 'supplier'
  end

  def board_member?
    member? && accountable_type == 'Building' && role == 'board_member'
  end

  def tenant?
    member? && accountable_type == 'Building' && role == 'tenant'
  end

  def agent?
    member? && accountable_type == 'Building' && role == 'agent'
  end

  def collaborator?
    member? && accountable_type == 'Company' && role == 'collaborator'
  end

  def member?
    has_community_and_role? && accepted?
  end

  # To avoid load every accountable object on every user query don't use accountable, use instead accountable_type and accoutable_id atts
  def has_community_and_role?
    ROLES.include?(role) && ACCOUTABLE_TYPES.include?(accountable_type) && accountable_id.present?
  end

  def self.community_class_by_role(role)
    case role
      when 'administrator' then Company
      when 'resident' then Building
      when 'tenant' then Building
      when 'agent' then Building
      when 'resident' then Building
      when 'supplier' then Business
      when 'collaborator' then Collaborator
    end
  end

  def full_name
    "#{first_name} #{last_name}".capitalize
  end

  def self.to_csv
    attributes = %w{id email name role locale apartment_numbers accountable actived}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| 
          #contact_details.
          if 'apartment_numbers' == attr && user.contact_details&.send(attr).present?
            user.contact_details&.send(attr)
          elsif 'accountable' == attr
            user.accountable.send('name') 
          elsif 'actived' == attr
            user.send('confirmed_at') 
          elsif 'apartment_numbers' != attr
            user.send(attr) 
          end
        }
      end
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def home_image
    images.where(home: true).first || ImageUser.new
  end

  def self.from_omniauth(auth, provider)
    skip_callback(:create, :after, :create_user_details)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.logo = auth.info.image
      user.build_contact_details ContactDetails.sanitize_oauth_params(auth.extra.raw_info, provider)
      user.skip_confirmation!
    end
  end

  def accountable
    self.old_accountable || NilAccountable.new
  end

  def status
    self.accepted ? I18n.t('users.active') : I18n.t('users.pending')
  end
  def update_with_password_first(params, *options)
    if options.present?
      ActiveSupport::Deprecation.warn <<-DEPRECATION.strip_heredoc
        [Devise] The second argument of `DatabaseAuthenticatable#update_with_password`
        (`options`) is deprecated and it will be removed in the next major version.
        It was added to support a feature deprecated in Rails 4, so you can safely remove it
        from your code.
      DEPRECATION
    end

    current_password = params.delete(:current_password)
    result = true
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    
    update(params, *options)
    

    clean_up_passwords
    result
  end


  def reject_path(company)
    if accepted
      Rails.application.routes.url_helpers.company_reject_accepted_user_path(company, user_id: self.id)
    else
      Rails.application.routes.url_helpers.company_reject_user_path(company, user_id: self.id)
    end
  end

  def display_details_in_select(current_user)
    if current_user.accountable_type == 'Company' && self.contact_details.apartment_numbers.present?
      unit_number = " - #{I18n.t('contacts.unit')} #{self.contact_details.apartment_numbers_joined}"
    end
    "#{self.accountable.name}#{unit_number}"
  end

  def root_folders
    folders = Folder.roots_by_user self
    folders = create_root_folders unless folders.present?
    folders
  end

  def has_payment_accounts?
     PaymentAccount.where(building: buildings).present?
  end

  def details_attr(d_attr)
    contact_details.try(d_attr.to_sym)
  end

  def leave_community(params)
    if id != params[:id].to_i
      errors.add :base, 'You are not authorized'
    elsif !valid_password?(params[:password])
      errors.add :base, 'Password incorrect'
    end
    return false if errors.any?
    Event.where(sender: self).destroy_all
    ServiceRequest.where(responsible: self).update_all(responsible_type: 'Company', responsible_id: my_company.id)
    reset_accountable_data
  end

  def reset_accountable_data
    update_attributes accountable: nil, role: nil, accepted: false
    run_callbacks(:destroy)
  end

  def profile_comments_for(user)
    user.shared_with_me comments.visible_for(user)
  end

  def news_feed_posts
    comments = Comment.where(commentable_type: 'User', commentable_id: contacts.ids << id)
    shared_with_me comments
  end

  def can_see_by_setting?(setting, other_user)    
    other_user.setting_for(setting) == 'public' || (other_user.contacts.ids.include?(self.id) && other_user.setting_for(setting) == 'my_community')
  end

  def can_see_user_name? user
    can_see_by_setting?("who_can_see_my_profile", user) || user.in_my_admins?(self) || self == user
  end

  def in_my_admins? user
    user.admin? && self.accountable_type == "Building" && user.buildings.ids.include?(self.accountable.id)
  end

  def can_do_by_setting? setting
    community = self.accountable
    
    case community.setting_for(setting)
    when "public"
      true
    when "community_members"
      community.users.ids.include?(self.id) || community.admins.ids.include?(self.id) || community.collaborators.ids.include?(self.id)
    when "management_only"
      community.admins.ids.include?(self.id)
    else
      true
    end
  end

  def notify_new_post(comment)
    UserMailer.new_wall_comment_user(comment).deliver_later if comment.user != self && setting_for('email_when_write_on_profile') == 'yes'
  end

  def notify_new_reply(comment)
    UserMailer.new_comment_reply(comment, email).deliver_later if  setting_for('email_when_reply_my_comment') == 'yes'
  end

  def notify_new_reply(comment)
    if setting_for('email_when_reply_my_comment') == 'yes'
      UserMailer.new_comment_reply(comment, email).deliver_later
    end
  end

  def first_name_letter
    self.logo? ? '' : first_name.to_s.chr
  end

  def self.near_by_ip(ip, distance)
    near_buildings = Building.near_by_ip(ip, distance).map &:id
    near_companies = Company.near_by_ip(ip, distance).map &:id
   
    User.where "(accountable_type = 'Company' AND accountable_id IN (?)) OR (accountable_type = 'Building' AND accountable_id IN (?))",
      near_companies, near_buildings
  end

  def self.near_by_community(community, distance)
    near_buildings = Building.near(community, distance).map &:id
    near_companies = Company.near(community, distance).map &:id
    
    User.where "(accountable_type = 'Company' AND accountable_id IN (?)) OR (accountable_type = 'Building' AND accountable_id IN (?))",
      near_companies, near_buildings
  end

  def shared_with_me(model_class)
    model_class.where id: shared_with_my_community_ids(model_class) + model_class.shared_public.ids
  end

  def is_contact(user)
    (contacts.ids + [id]).include? user.id
  end

  def reported_users
    User.marked_with self, 'reported'
  end

  def contacts_by_accountable
    mycontacts = contacts.group([:accountable_type,:accountable_id]).count
    qty_contacts = [];
    mycontacts.each do |key, value|
      
      qty_contacts.push(key[0].to_s + '-' + key[1].to_s => value.to_i)
    end
    qty_contacts
  end

  def contacts_by_accountable_off
    mycontacts = contacts.where(confirmed_at: nil).group([:accountable_type,:accountable_id]).count
    qty_contacts = [];
    mycontacts.each do |key, value|
      qty_contacts.push(key[0].to_s + '-' + key[1].to_s => value.to_i)
    end
    qty_contacts
  end

  # new function to set the password without knowing the current 
  # password used in our confirmation controller. 
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore. 
  # Instead you should use `pending_any_confirmation`.  
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_match?
    self.errors[:password] << I18n.t('errors.messages.blank') if password.blank?
    self.errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
    self.errors[:password_confirmation] << I18n.translate("errors.messages.confirmation", attribute: "password") if password != password_confirmation
    password == password_confirmation && !password.blank?
  end


  def send_confirmation_instructions
    unless @raw_confirmation_token
      generate_confirmation_token!
    end

    opts = pending_reconfirmation? ? { to: unconfirmed_email } : { }
    
    #admin unless current_user.present? = current_user
    send_devise_notification(:confirmation_instructions, @raw_confirmation_token, opts)
  end

private

  def set_from_invite
    create_contact_details
    if invite = Invite.find_by_id(invite_id) || Invite.find_by(email: email)
      self.assign_attributes({
        accountable: invite.accountable,
        role: invite.role,
        accepted: true,
        confirmed_at: Time.zone.now
      })

      self.contact_details.apartment_numbers << invite.apartment_number
      Invite.where(email: invite.email).destroy_all
    end
  end

  def set_role_from_accountable
    if role.blank? && accountable.present?
      self.role = {'Building' => 'tenant', 'Company' => 'administrator', 'Business' => 'supplier'}[accountable_type]
    end
  end

  def set_accountable_id
    if accountable_code.present?
      accountable = get_accountable_from_type_and_code
      self.accountable = accountable if accountable.present?
    end
  end

  def get_accountable_from_type_and_code
    if ACCOUTABLE_TYPES.include? accountable_type
      accountable_type.constantize.find_by_code(accountable_code)
    end
  end

  def accountable_exists
    if (accountable_type.present? or accountable_code.present?) and accountable_id.blank? and get_accountable_from_type_and_code.nil?
      errors.add(:accountable_code, :accountable_not_found)
    end
  end

  def create_user_details
    create_contact_details unless contact_details.present?
  end

  def send_update_email
    UserMailer.condo_media_update("A new user with email: #{email} has been sign up").deliver_later
  end

  def check_pending_invites
    is_already_invited = Invite.exists?(email: email, accountable: accountable, role: role)
    if is_already_invited
      self.accepted = true
      Invite.where(email: email, accountable: accountable).destroy_all
    end
  end

  def accountable_assigned?
    accountable_type && accountable_id
  end

  def contact_details_present?
    self.contact_details.present?
  end

  def check_for_user_balances
    UserBalance.for_apartments(accountable, self.contact_details.apartment_numbers).each do |user_balance|
      unless user_balance.users.include? self
        user_balance.users << self
      end
    end
  end

end