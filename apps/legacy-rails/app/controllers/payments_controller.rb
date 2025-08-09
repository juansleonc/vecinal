class PaymentsController < ApplicationController

  #load_and_authorize_resource
  skip_before_action :verify_authenticity_token, only: :create

  def index
    params[:order] ||= 'asc'
    @payments = set_pagination current_user.payments_associated.includes(:building), Payment::PER_PAGE, order_by: :transaction_date
    load_more_at_bottom_respond_to @payments
    # @page = params[:page] && params[:page].to_i > 0 ? params[:page].to_i : 0
    # @order = %w[asc desc].include?(params[:order]) ? params[:order].to_sym : :desc
    # @payments = current_user.payments_associated.limit(Payment::PER_PAGE).offset(@page * Payment::PER_PAGE).order(transaction_date: @order)
  end

  def create
    if params[:x_signature] == sha_from_response
      if payment_from_response.save
        flash[:notice] = 'Payment success'
      else
        flash[:error] = payment.errors.full_messages.join(', ')
      end
    else
      flash[:error] = 'Security issues'
    end
    redirect_to payments_path
  end

  def search
    @payments = set_pagination current_user.payments_associated.search_by(params[:query]).includes(:building),
      Payment::PER_PAGE, order_by: :transaction_date
    load_more_at_bottom_respond_to @payments
  end

private

  def payment_from_response
    Payment.new user: current_user, payment_account_id: params[:x_extra1], cust_id_cliente: params[:x_cust_id_cliente],
      description: params[:x_description], amount_ok: params[:x_amount_ok], amount_base: params[:x_amount_base], tax: params[:x_tax],
      service_fee: params[:x_extra2], id_invoice: params[:x_id_invoice], currency_code: params[:x_currency_code], bank_name: params[:x_bank_name],
      cardnumber: params[:x_cardnumber], business: params[:x_business], instalment: params[:x_instalment], franchise: params[:x_franchise],
      transaction_date: params[:x_transaction_date], approval_code: params[:x_approval_code], transaction_id: params[:x_transaction_id],
      response: params[:x_response], errorcode: params[:x_errorcode], customer_doctype: params[:x_customer_doctype],
      customer_document: params[:x_customer_document], customer_name: params[:x_customer_name], customer_lastname: params[:x_customer_lastname],
      customer_email: params[:x_customer_email], customer_phone: params[:x_customer_phone], customer_country: params[:x_customer_country],
      customer_city: params[:x_customer_city], customer_address: params[:x_customer_address], customer_ip: params[:x_customer_ip],
      amount_country: params[:x_amount_country], amount: params[:x_amount], cod_response: params[:x_cod_response],
      response_reason_text: params[:x_response_reason_text], signature: params[:x_signature]
  end

  def sha_from_response
    Digest::SHA256.hexdigest [params[:x_cust_id_cliente], current_user.accountable.payment_account.public_key,
      params[:x_ref_payco], params[:x_transaction_id], params[:x_amount], params[:x_currency_code]].join('^')
  end
end
