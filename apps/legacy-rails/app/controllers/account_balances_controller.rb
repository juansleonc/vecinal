class AccountBalancesController < ApplicationController

  load_and_authorize_resource

  def create
    @account_balance.assign_attributes(
      publication_date: Date.parse(account_balance_params[:publication_date]),
      publisher: current_user
    )

    if @account_balance.valid?
      @account_balance.save
      create_user_balances
    end
  end

  def destroy_all
    current_user.account_balances.destroy_all
  end

  private
  
  def account_balance_params
    params
      .require(:account_balance)
      .permit :subject, :publication_date, :community_type, :community_id,
        attachment_attributes: [:id, :file_attachment]
  end

  def create_user_balances
    file_attachment = account_balance_params[:attachment_attributes][:file_attachment]
    xls = Roo::Spreadsheet.open(file_attachment.tempfile.path)
    AccountBalance.create_user_balances_from_file(xls, @account_balance)
  end

end