class DealsController < ApplicationController

  before_action :set_business
  authorize_resource :business, except: :resident_index
  load_resource through: :business, except: [:create, :resident_index]
  authorize_resource

  skip_before_action :authenticate_user!, only: [:show, :add_click]

  def index
    @deals = @business.deals.order 'updated_at DESC'
  end

  def show
    @show_map = true
  end

  def new
    unless @business.stripe_user_id.present? && @business.stripe_publishable_key.present?
      flash[:error] = t 'deals.not_create_deals_until_register'
      redirect_to business_deals_path(@business)
    end
  end

  def create
    @deal = Deal.new(images_processed_params(deal_params))
    if saved = @deal.save
      process_images(@deal, saved)
      redirect_to business_deal_path(@business, @deal)
    else
      @deal.images.each { |image| image.save }
      process_images(@deal, saved)
      flash.now[:error] = @deal.flash_error
      render :new
    end
  end

  def edit
  end

  def update
    if @deal.update(deal_params)
      redirect_to business_deal_path(@business, @deal)
    else
      @deal.images.each { |image| image.save }
      render :edit
    end
  end

  def destroy
    @deal.destroy ? redirect_to( business_deals_path @business) : render(:edit)
  end

  def resident_index
    @show_map = true
    @near_businesses = Deal.near_by_business current_building
    render 'residents/deals/index'
  end

  def add_click
    @deal.add_click if !current_user || current_user.accountable_type == 'Building'
    redirect_to resident_business_deal_path(@business, @deal)
  end

  private

    def set_business
      @business = Business.find_by_namespace params[:namespace] || params[:business_namespace]
    end

    def deal_params
      params.require(:deal).permit(:category, :title, :price, :discount, :number, :show_contact, :secondary_phone_number,
        :secondary_email, :available_at, :finish_at, :description, :fine_print, :sign_agreement, :show_highlight,
        :show_top, :highlight_days, :top_days, :last_day_to_claim, :requires_shipping,
        images_attributes: [:id, :image, :home, :_destroy]
      ).merge! business_id: @business.id, stripe_card_token: params[:stripe_card_token]
    end

end
