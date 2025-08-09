module CouponsHelper
  def back_to_coupons(business)
    return business_public_coupons_deals_path(business) unless current_user
    current_user.accountable_type == 'Business' ? business_coupons_path(business) : resident_coupons_path
  end
end
