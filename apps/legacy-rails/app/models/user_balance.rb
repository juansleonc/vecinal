class UserBalance < ActiveRecord::Base

  PER_PAGE = 20
  FIRST_PAGE = 30

  belongs_to :account_balance
  has_many :user_balance_items, dependent: :destroy
  has_and_belongs_to_many :users

  delegate :publication_date, to: :account_balance
  delegate :community, to: :account_balance

  #before_save :check_for_resident

  scope :filtered_by_date, -> (date) { joins(:account_balance).where(account_balances: {publication_date: date}) }
  scope :filtered_by_year, -> (year) { joins(:account_balance).where('extract(year from account_balances.publication_date) = ?', year) }
  scope :filtered_by_building, -> (buildings) { joins(:account_balance).where(account_balances: { community_id: buildings }) }
  scope :for_community, -> (community) { joins(:account_balance).where account_balances: {community_id: community.id, community_type: community.class.name} }
  scope :for_apartments, -> (community, numbers) { for_community(community).where(apartment_number: numbers) }
  scope :for_admin, -> (admin) { joins(:account_balance).where(account_balances: {user_id: admin.company_contacts.ids}) }

  scope :search_by, -> (query) { distinct.where(
    'user_balances.apartment_number ILIKE :query OR user_balances.resident_name ILIKE :query',
    query: "%#{query}%"
  )}

  def self.for_user user
    user_balances = case user.role
    when "administrator" then for_admin(user)
    when "collaborator" then user.user_balances
    when "resident" then user.user_balances
    when "board_member" then user.user_balances
    when "tenant" then user.user_balances
    when "agent" then user.user_balances
    else UserBalance.none
    end
  end

  def self.filtered_by_month date_string
    date = date_string.blank? ? Date.current.beginning_of_month : Date.parse(date_string)
    filtered_by_date(date)
  end

  def self.filtered_by_community building_id, user = nil
    buildings = building_id.blank? ? user.buildings.ids : building_id.to_i
    filtered_by_building(buildings)
  end

  private

  #def check_for_resident
    #User.with_apartment(community, apartment_number).each do |user|
      #unless self.users.include? user
      #  self.users << user
      #end      
    #end
  #end

end