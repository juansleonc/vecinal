module HasLogo
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  ALLOWED_CONTENT_TYPES = ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  MAX_SIZE = 10.megabytes
  COLORS = %w[blue1 blue2 green1 green2 purple1 purple2 fuchsia orange brown yellow blue3]

  included do
    has_attached_file :logo, styles: { standard: '160x160#', square: '50x50#' }, default_url: :default_logo,
      processors: [:thumbnail, :compression]
    validates_attachment_content_type :logo, content_type: ALLOWED_CONTENT_TYPES
    validates_attachment_size :logo, less_than: MAX_SIZE
    attr_accessor :remove_logo
    after_validation :remove_logo_if_error
    before_save :destroy_logo?
  end

  def default_logo
    "logos/default_#{id % 11}_:style.png"
  end

  def destroy_logo?
    self.logo.clear if self.remove_logo == '1'
  end

  def remove_logo_if_error
    self.logo = nil if self.new_record? && self.errors.any?
  end

  def path_for_update_logo
    case self.class.name
      when 'User' then update_logo_user_path(id)
      when 'Business' then update_logo_business_path(namespace)
      when 'Building' then update_logo_building_path(company, self)
      when 'Company' then update_logo_company_path(namespace)
    end
  end

  def path_for_destroy_logo
    path_for_update_logo + '?destroy=true'
  end

  def first_name_letter
    self.logo? ? '' : name.to_s.chr
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

  end

end