class UserBalancesController < ApplicationController

  layout "balances_report", only: %i(print print_all)

  load_and_authorize_resource

  before_action :filter_data, only: %i(index destroy_selected print_all search)


  def index
    @submenu_title = t('general.account_balances')
    per_page = if params.has_key?(:page) && params[:page].to_i >= 1
      UserBalance::PER_PAGE
    else
      UserBalance::FIRST_PAGE
    end
    
    @action_for_search = search_user_balances_path(query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c], filter: 'test')
    @user_balances = @user_balances.order(:apartment_number).paginate(page: params[:page], per_page: UserBalance::PER_PAGE)

    
    
    load_more_at_bottom
  end

  def destroy
    @user_balance.destroy
  end

  def destroy_selected
    balances_selected = AccountBalance.where id: @user_balances.select(:account_balance_id).distinct
    balances_selected.destroy_all
  end

  def search
    @user_balances = set_pagination @user_balances.for_user(current_user).search_by(params[:query]),
      UserBalance::PER_PAGE

    load_more_at_bottom_respond_to @user_balances,
      html: 'user_balances/search_results',
      partial: 'user_balances/user_balance'
  end


  private

  def load_more_at_bottom
    load_more_at_bottom_respond_to @user_balances, html: 'user_balances/index',
      partial: 'user_balances/user_balance'
  end

  def user_balances_filtered_by_date
    case params[:type]
    when "year" then UserBalance.filtered_by_year(params[:filter])
    when "month" then UserBalance.filtered_by_month(Date.parse(params[:filter]))
    else UserBalance.none
    end
  end

  def building_present?
    params.has_key?(:b) &&
    params[:b].present? &&
    params[:b] != "undefined"
  end

  def filter_data
    @request_path = request.path
    @user_balances = @user_balances.filtered_by_month(params[:filter])


    group_building = current_user.my_company.buildings
    @contacts_by_accountable = [];

    @total_invites = 0
    group_building.each do |building|
      qty = 0
      @user_balances.each do |balance|
        if building[:id] == balance.account_balance.community_id
          qty = 1
          
        end
      end
      @total_invites += qty
      add_building = 'Building-' + building[:id].to_s
      show_qty = qty > 0 ? 1 : 0
      @contacts_by_accountable.push(add_building => show_qty)
    end
    

    @user_balances = @user_balances.filtered_by_community(params[:b], current_user)
  end
end