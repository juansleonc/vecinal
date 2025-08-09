class Company < ActiveRecord::Base

  include Accountable
  include HasLogo
  include StripeCalls
  include Folderable
  include Reviewable
  include Geocodeable
  include Settingable
  include SettingableCommunity

  PER_PAGE = 20
  CATEGORIES = %w[property_managers real_estate hoa cooperative other]
  INVITES_PER_PAGE = 20
  PLANS = [
    {name: 'basic', space: '5 GB', price: 0, online_payments: false},
    {name: 'premiun', space: '100 GB', price: 40, online_payments: true},
    {name: 'pro', space: '1 TB', price: 70, online_payments: true},
    {name: 'elite', space: '5 TB', price: 100, online_payments: false},
  ]
  
  has_many :buildings, dependent: :destroy
  has_many :apartments, through: :buildings
  has_many :images, as: :imageable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy # Wall posts
  has_many :users, through: :buildings
  has_many :amenities, through: :buildings

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :owner, presence: true
  validates :name, presence: true
  validates :namespace, presence: true, format: { with: /\A[a-z\-\_0-9]*\z/, message: :namespace_format}, length: { maximum: 30 }, uniqueness: true
  # validates :category, inclusion: { in: CATEGORIES, allow_blank: true }
  validates :email, format: { with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i, allow_blank: true }
  # validates :phone, presence: true
  validates :country, presence: true
  validates :region, presence: true
  validates :city, presence: true
  validates :address, presence: true
  # validates :zip, presence: true
  validates :confirm_legal_representation, acceptance: true

  alias_attribute :subdomain, :namespace

  after_create do
    create_stripe_subscription plan_id: 'adm_basic'
  end

  after_create :send_update_email

  scope :search_by, -> (query) { distinct.where(
    'name ILIKE :query OR country ILIKE :query OR city ILIKE :query OR address ILIKE :query',
    query: "%#{query}%"
  )}

  def to_param
    namespace
  end

  def full_address
    "#{address}, #{city}, #{region}, #{zip}, #{country}"
  end

  def display_address
    "#{address}, #{city}, #{zip}"
  end

  def home_image
    self.images.where(home: true).first || ImageCompany.new
  end

  def first_apartment
    @first_apartment ||= (self.apartments.last || Apartment.new)
  end

  def first_building
    @first_building ||= (self.buildings.last || Building.new)
  end

  def administrators_and_residents
    related_users.where(accepted: true)    
  end

  def requests
    related_users.where(accepted: false)
  end

  def related_users
    User.where("(accountable_type = 'Company' AND accountable_id = ? )OR (accountable_type = 'Building' AND accountable_id IN (?))",
      id, buildings.ids
    )
  end

  def administrators
    User.where(accepted: true, accountable_type: 'Company', accountable_id: self.id)
  end
  
 

  def news_feed_posts(user)
    # Comment.where(
    #   '(commentable_type = ? AND commentable_id = ?) OR (commentable_type = ? AND commentable_id IN (?))', 'Company', id, 'Building', buildings.ids
    # ).order(updated_at: :desc).limit(100)
    # user.present? ? comments.shared_for(user) : Comment.none
    user.present? ? user.shared_with_me(comments.visible_for user) : Comment.none
  end

  def can_create_buildings?
    return false unless %w[active past_due].include?(self.stripe_subscription_status)
    number_buildings = self.buildings.count
    (self.stripe_subscription_plan == 'adm_basic' && number_buildings < max_buildings_on_basic_plan) ||
    (self.stripe_subscription_plan == 'adm_premium' && number_buildings < max_buildings_on_premium_plan) ||
    (self.stripe_subscription_plan == 'adm_pro' && number_buildings < max_buildings_on_pro_plan)
  end

  def max_buildings_on_basic_plan
    (Rails.application.secrets.max_buildings_on_basic_plan || 5).to_i
  end

  def max_buildings_on_premium_plan
    (Rails.application.secrets.max_buildings_on_premium_plan || 10).to_i
  end

  def max_buildings_on_pro_plan
    (Rails.application.secrets.max_buildings_on_pro_plan || 1000).to_i
  end

  def plans
    stripe_plans 'adm'
  end

  def link_to_subscriptions
    Rails.application.routes.url_helpers.company_stripe_subscription_path(self.namespace)
  end

  def validates_upgrade_downgrade_plan(old_plan, new_plan)
    number_buildings = self.buildings.count
    if (old_plan == new_plan) || (old_plan == 'adm_basic') || (new_plan == 'adm_pro') ||
      (new_plan == 'adm_basic' && number_buildings <= max_buildings_on_basic_plan) ||
      (new_plan == 'adm_premium' && number_buildings <= max_buildings_on_premium_plan)
      return true
    else
      errors.add :base, :can_not_update_plan
      return false
    end
  end

  def buildings_by_plan(plan)
    case plan
      when 'adm_basic' then max_buildings_on_basic_plan
      when 'adm_premium' then max_buildings_on_premium_plan
      when 'adm_pro' then I18n.t('companies.plans.unlimited')
    end
  end

  def path_to_public_apartment(apartment)
    Rails.application.routes.url_helpers.company_public_apartment_path(self, apartment)
  end

  def reservations
    Reservation.joins(:amenity).where amenities: { building_id: buildings }
  end

  def secure_destroy(params)
    if params[:namespace] != namespace
      errors.add :base, 'Wrong Company'
    elsif owner != params[:owner]
      errors.add :base, 'Only owner can destroy company'
    elsif !owner.valid_password?(params[:password])
      errors.add :base, 'Password incorrect'
    end
    return false if errors.any?
    Company.transaction do
      self.destroy
      (users + admins).each do |user|
        user.reset_accountable_data
      end
    end
  end

  def link_to_home(host)
    Rails.application.routes.url_helpers.company_root_url(self, subdomain: 'www', host: host)
  end

  def contacts
    admins
  end

  def notify_new_post(comment)
    UserMailer.new_wall_comment_company(comment).deliver_later if setting_for('email_when_post_timeline') == 'yes'
  end

  def notify_new_review(review)
    UserMailer.new_review_company(review).deliver_later if setting_for('email_when_review') == 'yes' && email.present?
  end

  def all_users
    users.ids + admins.ids 
  end

private

  def send_update_email
    UserMailer.condo_media_update("A new company: #{name}, has been created.").deliver_now
  end

end
