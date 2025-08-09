class FinishRegistrationController < ApplicationController

  # skip_before_action :check_registration_finished, only: [:roles, :set_role, :companies, :buildings, :create_community, :cancel,
    # :search_buildings, :search_companies, :send_property_manager_invitation]

  before_action :check_user, only: [:buildings, :companies]

  def companies
    @companies = set_pagination Company.nearby_from(request.remote_ip, request.location.country, 1000).includes(:images), Company::PER_PAGE
    load_more_at_bottom_respond_to @companies, partial: 'finish_registration/community'
  end

  def buildings
    @buildings = set_pagination Building.nearby_from(request.remote_ip, request.location.country, 1000).includes(:images), Building::PER_PAGE
    load_more_at_bottom_respond_to @buildings, partial: 'finish_registration/community'
  end

  def search_companies
    @communities = set_pagination Company.search_by(params[:query]).includes(:images), Company::PER_PAGE
    @action_for_search = finish_registration_search_companies_path(query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c])
    @model_name = Company.model_name.human(count: 2).capitalize
    render 'search'
  end

  def search_buildings
    @communities = set_pagination Building.search_by(params[:query]).includes(:images), Building::PER_PAGE
    @action_for_search = finish_registration_search_buildings_path(query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c])
    @model_name = Building.model_name.human(count: 2).capitalize
    render 'search'
  end

  def set_role
    current_user.update user_params
    if current_user.accountable.present?
      current_user.accountable.admins.each do |admin|
        UserMailer.new_join_request(current_user, admin).deliver_later if admin.setting_for('email_when_new_join_request') == 'yes'
      end
    end
  end

  def create_community
    if params[:company].present?
      @company= Company.new(company_params)
      if @company.save
        current_user.reload
        flash[:notice] = "Company created successfully"
      end
    end
  end

  def send_property_manager_invitation
  end

  def cancel
    @community = current_user.accountable
    current_user.reset_accountable_data
  end

private

  def user_params
    params.require(:user).permit( :accountable_type, :accountable_code )
  end

  def company_params
    params.require(:company).permit( :name, :namespace, :category, :email, :phone, :extension, :country, :region,
      :city, :address, :zip, :confirm_legal_representation ).merge!(owner: current_user)
  end

  def check_user
    redirect_to news_feed_path if current_user.accepted
  end

end
