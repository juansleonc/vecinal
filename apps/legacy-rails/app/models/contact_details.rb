class ContactDetails < ActiveRecord::Base

  attr_accessor :apartment_numbers_string

  belongs_to :user
  validates :user, presence: true
  serialize :apartment_numbers, Array

  before_validation :set_apartment_numbers

  def self.sanitize_oauth_params(info, provider)
    case provider
    when 'facebook'
      sanitize_facebook_oauth_params(info)
    when 'linkedin'
      sanitize_linkedin_oauth_params(info)
    when 'google_oauth2'
      sanitize_google_oauth_params(info)
    else
      {}
    end
  end

  def apartment_numbers_joined
    apartment_numbers.join(', ')
  end

private

  def self.sanitize_facebook_oauth_params(info)
    params = {}
    params[:sex] = info.gender == 'female' ? 'f' : 'm'
    params[:birth_day] = Date.strptime(info.birthday, '%m/%d/%Y') if info.birthday
    params[:birth_year] = Date.strptime(info.birthday, '%m/%d/%Y').year if info.birthday
    params[:education] = info.education.last.school.name if info.education
    params[:hometown] = info.hometown.name if info.hometown
    params[:work] = info.work.last.employer.name if info.work
    params[:links] = info.website if info.website

    params
  end

  def self.sanitize_linkedin_oauth_params(info)
    params = {}
    params[:hometown] = info.location.name if info.location
    params[:work] = info.positions.values.last.last.company.name if info.positions && info.positions.values.present? && info.positions.values.last.is_a?(Array)
    params
  end

  def self.sanitize_google_oauth_params(info)
    params = {}
    params[:sex] = info.gender == 'female' ? 'f' : 'm'
    params
  end

  def set_apartment_numbers
    if apartment_numbers_string
      self.apartment_numbers = apartment_numbers_string.split(',').map(&:strip).compact.reject{|e| e.empty?}
    end
  end
end

