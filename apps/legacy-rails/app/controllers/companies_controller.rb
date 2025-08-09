class CompaniesController < ApplicationController
  before_action :get_members_roles, only: [:invites_received, :invites_sent]
  before_action :get_administrative_roles, only: [:invites_received, :invites_sent]
  before_action :set_company
  before_action :set_filter, only: :invites_received
  authorize_resource

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to company_public_about_url(@company)
    else
      @company.images.each { |image| image.save }
      flash[:error] = @company.errors.full_messages.join(', ')
      redirect_to company_public_about_url(@company)
    end
  end

  def invites_sent
    @sent_tab = 'active'
    
    @communities_invites = current_user.contacts_off.group([:accountable_type,:accountable_id]).count
    
    
    qty_invites = [];
    @communities_invites.each do |key, value|
      qty_invites.push(key[0].to_s + '-' + key[1].to_s => value.to_i)
    end
    
    @communities_invites = qty_invites
    @total_invites = 0
    @communities_invites.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end
    
    @invites_sent = set_pagination current_user.contacts_off, Company::INVITES_PER_PAGE
    load_more_at_bottom_respond_to @invites_sent, html: 'invites/sent', partial: 'invites/invite_sent'
  end

  def invites_received
    params[:order] ||= 'asc'
    @received_tab = 'active'
    if params[:order] == 'last'
      @invites_received = @company.requests.order(:id => 'DESC').paginate(page: params[:page], per_page: Company::INVITES_PER_PAGE)    
    elsif params[:order] == 'oldest'
      @invites_received = @company.requests.order(:id => 'ASC').paginate(page: params[:page], per_page: Company::INVITES_PER_PAGE)    
    else
      @invites_received = @company.requests.order(:first_name => params[:order].to_sym).paginate(page: params[:page], per_page: Company::INVITES_PER_PAGE)    
    end
    

    @total = @invites_received.count
    @submenu_title = t 'invites.invites'
    @submenu_item = 'invites'
    @action_for_search = search_invites_received_company_path(current_user.accountable, query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c])
    @contacts_by_accountable = [];
    load_more_at_bottom_respond_to @invites_received, html: 'invites/received', partial: 'invites/invite_received'
  end
  def set_filter
    myinvites = @company.requests.group([:accountable_type,:accountable_id]).count
    @contacts_by_accountable = [];
    myinvites.each do |key, value|
      @contacts_by_accountable.push(key[0].to_s + '-' + key[1].to_s => value.to_i)
    end
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end
  end
  

  def accept_user
    @user = @company.requests.find(params[:user_id])
    @user.update accepted: true
    UserMailer.request_processed(@user).deliver_later
  end

  def reject_user
    @user = @company.requests.find(params[:user_id])
    UserMailer.request_processed(@user).deliver_later
    @user.contact_details.update_columns apartment_numbers: [], move_in_date: nil if @user.contact_details
    @user.update_columns role: nil, accountable_type: nil, accountable_id: nil
  end

  def reject_accepted_user
    @user = @company.related_users.find(params[:user_id])
    @user.update_columns role: nil, accountable_type: nil, accountable_id: nil, accepted: false
    respond_to do |format|
      format.html { redirect_to company_root_path(@company) }
      format.js { render 'reject_user' }
    end
  end

  def stripe_subscription
    @subscriptions_tab = 'active'
  end

  def stripe_plans
    @plans_tab = 'active'
  end

  def save_stripe_subscription
    if @company.save_subscription(stripe_subscription_params)
      flash[:notice] = t 'subscriptions.subscription_made_correctly'
      redirect_to news_feed_path(@company.namespace)
    else
      flash.now[:error] = @company.errors.full_messages.join(', ')
      render 'stripe_subscription'
    end
  end

  def list_invoices
    @invoices = @company.invoices
    @model_object = @company
    flash.now[:error] = @company.errors.full_messages.join(', ')
    @invoices_tab = 'active'
    render 'invoices/index'
  end

  def update_logo
    logo = params[:destroy] ? nil : params[:company][:logo]
    @company.update logo: logo
    redirect_to :back
  end

  def search_invites_received
    params[:order] ||= 'asc'
    @invites_received = set_pagination @company.requests.search_by(params[:query]), Company::INVITES_PER_PAGE, order_by: :first_name
    load_more_at_bottom_respond_to @invites_received, html: 'invites/search_received_results', partial: 'invites/invite_received'
  end

  def destroy
    @company.secure_destroy(destroy_params)
    flash[:notice] = "Company destroyed"  if @company.destroyed?
  end

  def update_settings
    @company.update_settings params.require(:setting).permit(*(SettingableCommunity::NOTIFICATIONS + SettingableCommunity::PROFILE))
    redirect_to company_public_settings_url(@company)
  end

private

  def get_members_roles
    @members_roles = [
      {
        :id => 'resident', 
        :name => t('roles.resident')
      },
      {
        :id => 'board_member', 
        :name => t('roles.board_member')
      },
      {
        :id => 'tenant', 
        :name => t('roles.tenant')
      },
      {
        :id => 'agent', 
        :name => t('roles.agent')
      }
      
    ]
  end
  def get_administrative_roles
    @administrative_roles = [
      {
        :id => 'administrator', 
        :name => t('roles.administrator')
      },
      {
        :id => 'collaborator', 
        :name => t('roles.collaborator')
      }
    ]
  end

  def set_company
    @company = Company.find_by(namespace: (params[:namespace] || params[:company_namespace]))
  end

  def company_params
    params.require(:company).permit(:user_id, :namespace, :name, :category, :email, :phone, :extension, :country,
      :region, :city, :address, :zip, :fax, :opening_hours, :website, :description, :logo, :remove_logo, :managed_by,
      images_attributes: [:id, :image, :home, :_destroy]
    )
  end

  def stripe_subscription_params
    params.permit :stripe_card_token, :plan_id, :sign_agreement
  end

  def destroy_params
    params.permit(:namespace, :password).merge(owner: current_user)
  end

end
