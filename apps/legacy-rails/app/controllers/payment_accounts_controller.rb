class PaymentAccountsController < ApplicationController

  def index
    @payment_accounts = current_user.buildings.paginate(page: params[:page], per_page: PaymentAccount::PER_PAGE)
    
    load_more_at_bottom_respond_to @payment_accounts, partial: 'payment_accounts/payment_account'
  end

  def new
    building = current_user.buildings.find_by_subdomain params[:building_subdomain]
    @account = PaymentAccount.new building: building
  end

  def create
    @account = PaymentAccount.new create_params
    if @account.save
      UserMailer.report_payment_account_updated(@account, current_user).deliver_now
    end
  end

  def edit
    @account = PaymentAccount.find params[:id]
  end

  def update
    @account = PaymentAccount.find params[:id]
    if @account.update_attributes update_params
      status = @account.enable_payments ? 'in_progress' : 'disabled'
      @account.update(status: status)
      UserMailer.report_payment_account_updated(@account, current_user).deliver_now
    end
  end

private

  def create_params
    params.require(:payment_account).permit :building_id, :country, :bank_name, :account_name, :account_type, :transit_number,
      :institution_number, :routing_number, :account_number, :enable_payments
  end

  def update_params
    params.require(:payment_account).permit :bank_name, :account_name, :account_type, :transit_number, :institution_number,
      :routing_number, :account_number, :enable_payments
  end

end
