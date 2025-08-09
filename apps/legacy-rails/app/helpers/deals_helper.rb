module DealsHelper
  def back_to_deals(business)
    return business_public_coupons_deals_path(business) unless current_user
    current_user.accountable_type == 'Business' ? business_deals_path(business) : resident_deals_path
  end
end
