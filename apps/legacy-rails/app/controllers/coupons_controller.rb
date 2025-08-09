class CouponsController < ApplicationController

  before_action :set_business
  authorize_resource :business, except: :resident_index
  load_resource through: :business, except: [:create, :resident_index]
  authorize_resource

  skip_before_action :authenticate_user!, only: [:show, :add_click]

  def index
    @coupons = @coupons.order 'updated_at DESC'
  end

  def show
    @show_map = true
  end

  def new
    unless @coupon.can_create_coupon?
      flash[:error] = @coupon.flash_error
      redirect_to business_coupons_path(@business)
    end
  end

  def create
    @coupon = Coupon.new(images_processed_params(coupon_params))
    if saved = @coupon.save
      process_images(@coupon, saved)
      redirect_to business_coupon_path(@business, @coupon)
    else
      @coupon.images.each { |image| image.save }
      process_images(@coupon, saved)
      flash.now[:error] = @coupon.flash_error
      render :new
    end
  end

  def edit
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to business_coupon_path(@business, @coupon)
    else
      @coupon.images.each { |image| image.save }
      flash.now[:error] = @coupon.flash_error
      render :edit
    end
  end

  def destroy
    @coupon.destroy ? redirect_to(business_coupons_path @business) : render(:edit)
  end

  def resident_index
    @show_map = true
    @near_businesses = Coupon.near_by_business current_building
    render 'residents/coupons/index'
  end

  def add_click
    @coupon.add_click if !current_user || current_user.accountable_type == 'Building'
    redirect_to resident_business_coupon_path(@business, @coupon)
  end

  private

    def set_business
      @business = Business.find_by_namespace params[:namespace] || params[:business_namespace]
    end

    def coupon_params
      params.require(:coupon).permit(:category, :title, :number, :show_contact, :secondary_phone_number,
        :secondary_email, :available_at, :finish_at, :description, :fine_print, :sign_agreement, :show_highlight,
        :show_top, :highlight_days, :top_days, :last_day_to_claim, :price,
        images_attributes: [:id, :image, :home, :_destroy]
      ).merge! business_id: @business.id, stripe_card_token: params[:stripe_card_token]
    end

end
