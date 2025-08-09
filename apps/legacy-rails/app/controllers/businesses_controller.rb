class BusinessesController < ApplicationController

  # skip_before_action :check_registration_finished, only: [:create]
  before_action :set_params_id_by_namespace, except: [:stripe_response, :nearby]
  load_resource find_by: :namespace, except: [:stripe_response, :nearby]
  authorize_resource

  include HTTParty

  def welcome
    render 'suppliers/welcome'
  end

  def edit
  end

  def update
    if @business.update business_params
      redirect_to business_root_path(@business)
    else
      @business.images.each { |image| image.save }
      render 'edit'
    end
  end

  def stripe_connect
    redirect_to "https://connect.stripe.com/oauth/authorize?#{params.to_query}"
  end

  def stripe_response
    code = stripe_params[:code]
    @business = Business.find_by_namespace stripe_params[:state]
    if code.present?
      response = HTTParty.post('https://connect.stripe.com/oauth/token',
        query: {
          client_secret: Rails.application.secrets.stripe_secret_key,
          code: code,
          grant_type: 'authorization_code'
        }
      )
      if response['access_token'].present?
        @business.update stripe_user_id: response['stripe_user_id'], stripe_publishable_key: response['stripe_publishable_key']
        flash[:notice] = t('subscriptions.stripe_successfully_connected')
      else
        # Error from response
        flash[:error] = t 'subscriptions.was_problem_with_payment_info'
      end
    else
      # Error from Stripe
      flash[:error] = t 'subscriptions.stripe_problem_connecting_payment_account'
    end
    redirect_to business_root_path(@business.namespace)
  end

  def stripe_subscription
  end

  def save_stripe_subscription
    if @business.save_subscription(stripe_subscription_params)
      flash[:notice] = t 'subscriptions.subscription_made_correctly'
      redirect_to business_root_path(@business.namespace)
    else
      flash.now[:error] = @business.errors.full_messages.join(', ')
      render 'stripe_subscription'
    end
  end

  def list_invoices
    @invoices = @business.invoices
    @model_object = @business
    flash.now[:error] = @business.errors.full_messages.join(', ')
    render 'invoices/index'
  end

  def batch_redeem
    params[:query] ||= ''
    if params[:query].present?
      if params[:promo] == 'coupon'
        @coupon_redemptions = CouponRedemption.batch_redeem params[:query], @business
        flash.now[:notice] = t('coupon_redemptions.coupons_are_redeemed').capitalize unless @coupon_redemptions.empty?
      elsif params[:promo] == 'deal'
        @deal_purchases = DealPurchase.batch_purchase params[:query], @business
        flash.now[:notice] = t('deal_purchases.deals_are_redeemed') unless @deal_purchases.empty?
      end
    end
    render 'suppliers/batch_redeem'
  end

  def reports
    render 'suppliers/reports'
  end

  def payments
    @payments = @business.payments
    render 'suppliers/payments'
  end

  def nearby
    @show_map = true
    @businesses = Business.near_reference current_user.accountable, MAX_DISTANCE_FROM_BUILDING
    render 'residents/promotions/businesses_nearby'
  end

  def update_logo
    logo = params[:destroy] ? nil : params[:business][:logo]
    @business.update logo: logo
    redirect_to :back
  end

  def account_balances
    render 'account_balances/index'
  end

private

    def business_params
      params.require(:business).permit(:name, :namespace, :description, :phone, :extension, :email, :opening_hours,
        :website, :country, :region, :city, :address, :zip, :logo, :remove_logo, :location,
        images_attributes: [:id, :image, :home, :_destroy]
      )
    end

    def set_params_id_by_namespace
    	params[:id] = params[:namespace] || params[:business_namespace]
    end

    def stripe_params
      params.permit :code, :scope, :state, :error, :error_description
    end

    def stripe_subscription_params
      params.permit :stripe_card_token, :plan_id, :sign_agreement
    end

end
