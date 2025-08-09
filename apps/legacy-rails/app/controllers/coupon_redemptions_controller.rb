class CouponRedemptionsController < ApplicationController

  load_resource except: [:print, :index, :batch_redeem]
  authorize_resource
  skip_before_action :authenticate_user!, only: :print

  def index
    @coupon = Coupon.find params[:coupon_id]
    @coupon_redemptions = CouponRedemption.where coupon_id: params[:coupon_id]
  end

  def show
    render :show, layout: false
  end

  def print
    if current_user
      @coupon_redemption = CouponRedemption.find_current_or_create current_user.id, params[:coupon_id]
      if @coupon_redemption.valid?
        redirect_to coupon_redemption_path(@coupon_redemption.id)
      else
        flash[:error] = @coupon_redemption.errors.full_messages.join(', ')
        redirect_to :back
      end
    else
      flash[:error] = t 'promotions.voucher_only_for_condomedia_users'
      redirect_to :back
    end
  end

  def redeem
    @coupon_redemption.update redeemed: true
    render 'update_coupon_redemption'
  end

  def unredeem
    @coupon_redemption.update redeemed: false
    render 'update_coupon_redemption'
  end

end
