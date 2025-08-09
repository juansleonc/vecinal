class DealPurchasesController < ApplicationController

  load_resource except: [:index, :batch_purchase, :pay]
  authorize_resource
  skip_before_action :authenticate_user!, only: :pay

  def index
    @deal = Deal.find params[:deal_id]
    @deal_purchases = DealPurchase.where deal_id: params[:deal_id]
  end

  def show
    render :show, layout: false
  end

  def pay
    if current_user
      @deal_purchase = DealPurchase.new user_id: current_user.id, deal_id: params[:deal_id],
        address: current_user.accountable.address, city: current_user.accountable.city,
        region: current_user.accountable.region, country: current_user.accountable.country
    else
      flash[:error] = t 'promotions.voucher_only_for_condomedia_users'
      redirect_to :back
    end
  end

  def create
    if @deal_purchase.save
      redirect_to deal_purchase_path(@deal_purchase)
    else
      render 'pay'
    end
  end

  def redeem
    @deal_purchase.update status: 'redeemed'
    render 'update_deal_purchase'
  end

  def unredeem
    @deal_purchase.update status: 'not_redeemed'
    render 'update_deal_purchase'
  end

  private

    def deal_purchase_params
      params.require(:deal_purchase).permit(:user_id, :deal_id, :price, :quantity, :address, :city, :region, :country,
        :sign_agreement).merge stripe_card_token: params[:stripe_card_token]
    end

end
