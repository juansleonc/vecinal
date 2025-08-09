class Building < ActiveRecord::Base

  include HasLogo
  include Folderable
  include Reviewable
  include Geocodeable
  include Settingable
  include SettingableCommunity

  PER_PAGE = 20

  RESERVED_SUBDOMAINS = %w[admin administrator api assets atom billing bugs blog calendar chat community dashboard
    demo dev developer developers development docs download email embedded example faq feed feeds feedback
    files forum ftp git guide help img images imap inbox index invite irc jobs kb knowledgebase lab legal
    login mail m mobile manage map media messages my news official pay payment policy portal private public
    pop pop3 register root rss search secure setting shop sites sitemap smtp ssl stage staging status stats
    static store support system tag team test tool tos update upgrade upload uploads users video videos webmaster
    webmail wiki www]

  CATEGORIES = %w[condominiums apartment_building student_housing senior_housing]

  belongs_to :company
  has_many :images, as: :imageable, dependent: :destroy
  has_many :apartments, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy # Wall posts
  has_many :users, as: :accountable

  has_many :amenities, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :classifieds, dependent: :destroy
  has_one  :payment_account, dependent: :destroy
  has_many :payments, through: :payment_account
  has_many :accountable_balances, as: :community

  belongs_to :admin_default, foreign_key: 'admin_default_requests', class_name: 'User'

  accepts_nested_attributes_for :images, allow_destroy: true

  validates :name, presence: true
  validates :subdomain, presence: true, format: { with: /\A[a-z0-9][a-z0-9\-]*[a-z0-9]\Z/, message: :subdomain_format, allow_blank: true}, length: { maximum: 30 }, uniqueness: true, exclusion: { in: RESERVED_SUBDOMAINS }
  # validates :size, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # validates :category, inclusion: { in: CATEGORIES, allow_blank: true }
  validates :country, presence: true
  validates :region, presence: true
  validates :city, presence: true
  validates :address, presence: true
  # validates :zip, presence: true

  before_create :set_code, :set_country_code, :set_admin_default_requests
  after_create :send_update_email

  scope :payments_enabled, -> { joins(:payment_account).where payment_accounts: { status: 'active' } }

  scope :search_by, -> (query) { distinct.where(
    'name ILIKE :query OR country ILIKE :query OR city ILIKE :query OR address ILIKE :query',
    query: "%#{query}%"
  )}

  def full_address
    "#{address}, #{city}, #{region}, #{zip}, #{country}"
  end

  def display_address
    "#{address}, #{city}, #{zip}"
  end

  def home_image
    images.where(home: true).first || ImageBuilding.new
  end

  def first_apartment
    @first_apartment ||= (self.apartments.last || Apartment.new)
  end

  def category_translation
    self.category.present? ? I18n.t("general.building_types.#{self.category}") : ''
  end

  def to_param
    subdomain
  end

  def news_feed_posts(user)
    # Comment.where(['(commentable_type = ? AND commentable_id = ?) OR (commentable_type = ? AND commentable_id = ?)', 'Company', self.company.id, 'Building', self.id]).order('updated_at DESC').limit(100)
    # user.present? ? comments.shared_for(user) : Comment.none
    user.present? ? user.shared_with_me(comments.visible_for user) : Comment.none
  end

  def path_to_public_apartment(apartment)
    Rails.application.routes.url_helpers.building_apartment_path(apartment)
  end

  def businesses_near
    Business.near_reference self, MAX_DISTANCE_FROM_BUILDING
  end

  def payments_enabled?
    payment_account && payment_account.status == 'active'
  end

  def country_code_from_geocoder
    places = Geocoder.search("#{latitude}, #{longitude}")
    places.first.country_code if places.present?
  end

  def payments_enabled_label
    payments_enabled? ? I18n.t('payment_accounts.online_payments.enabled') : I18n.t('payment_accounts.online_payments.disabled')
  end

  def payments_enabled_color
    payments_enabled? ? 'green' : 'black'
  end

  def payments_status
    payment_account.present? ? payment_account.status : 'nil'
  end

  def payments_status_color
    payment_account.present? ? PaymentAccount::STATUS_COLORS[payment_account.status.to_sym] : 'black'
  end

   def secure_destroy(params)
    if !company.admins.include?(params[:user])
      errors.add :base, 'Only an admin can destroy building'
    elsif !params[:user].valid_password?(params[:password])
      errors.add :base, 'Password incorrect'
    end
    return false if errors.any?
    Building.transaction do
      self.destroy
      users.each do |user|
        user.reset_accountable_data
      end
    end
  end

  def link_to_home(host)
    Rails.application.routes.url_helpers.building_root_url(subdomain: self, host: host)
  end

  def contacts
    users + company.admins
  end

  def all_users
    users.ids + company.admins.ids
  end

  def admins
    company.admins
  end

  def get_admin_default_requests
    id_admin = self.admin_default_requests > 0 ? self.admin_default_requests  : self.company.user_id;
    User.where("id = ? ", id_admin).first
  end

  def name_admin_default_requests
    if get_admin_default_requests
      get_admin_default_requests.first_name + ' ' + get_admin_default_requests.last_name
    end
  end

  def get_admin_default_reservations
    id_admin = self.admin_default_reservations > 0 ? self.admin_default_reservations  : self.company.user_id;
    User.where("id = ? ", id_admin).first
  end

  def name_admin_default_reservations
    if get_admin_default_reservations
      get_admin_default_reservations.first_name + ' ' + get_admin_default_reservations.last_name
    end
  end

  def related_admins
    User.where("accountable_type = 'Company' AND accountable_id = ?",
      company.id
    )
  end 

  def administrators_and_residents
    related_users.where(accepted: true)
  end



  def related_users
    User.where("(accountable_type = 'Company' AND accountable_id = ? ) OR (accountable_type = 'Building' AND accountable_id = ?)",
      company.id,  id
    )
  end

  def notify_new_post(comment)
    UserMailer.new_wall_comment_building(comment).deliver_later if setting_for('email_when_post_timeline') == 'yes' && email.present?
  end

  def notify_new_review(review)
    UserMailer.new_review_building(review).deliver_later if setting_for('email_when_review') == 'yes' && email.present?
  end

private

  def set_code
    self.code = SecureRandom.hex(3)
    while Building.where(code: self.code).first.present?
      self.code = SecureRandom.hex(3)
    end
  end

  def set_country_code
    self.country_code = country_code_from_geocoder
  end

  def set_admin_default_requests    
    self.admin_default_requests = company.user_id
  end

  def send_update_email
    UserMailer.condo_media_update("A new building: #{name}, has been created").deliver_later
  end

end
