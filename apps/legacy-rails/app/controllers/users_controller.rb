class UsersController < ApplicationController

  include MarkableCalls
  before_action :get_members_roles
  before_action :get_administrative_roles
  #before_action :change_password

  load_and_authorize_resource
  # skip_before_action :check_registration_finished, only: [:report_software_problem, :create_report_software_problem]
  before_action :set_company, only: [:edit, :update]

  def index
    params[:order] ||= 'asc'
    if params[:order] == 'last'
      @users = @users.where(accountable: current_user.accountable).order(:id => 'DESC').paginate(page: params[:page], per_page: User::USERS_PER_PAGE)
    elsif params[:order] == 'oldest'
      @users = @users.where(accountable: current_user.accountable).order(:id => 'ASC').paginate(page: params[:page], per_page: User::USERS_PER_PAGE)      
    else
      @users = @users.where(accountable: current_user.accountable).order(:first_name => params[:order].to_sym).paginate(page: params[:page], per_page: User::USERS_PER_PAGE)
    end
    
    @order = %w[asc desc last oldest].include?(params[:order]) ? params[:order].to_sym : :desc
    @total = @users.count
    load_more_at_bottom_respond_to @users
  end

  def edit
  end

  def update
    if @user.update(user_edit_params)
      redirect_to company_users_path(current_user.accountable, subdomain: 'www')
    else
      render :edit
    end
  end

  def my_stuff
    @vouchers = (current_user.redemptions + current_user.purchases).sort_by { |k| k.created_at }.reverse
    render 'residents/promotions/my_stuff'
  end

  def create_report_software_problem
    @report_software_problem_form = ContactForm.new(params[:contact_form])
    UserMailer.report_software_problem(@report_software_problem_form, current_user).deliver_now if @report_software_problem_form.valid?
  end

  def report_software_problem
  end

  def finish_tour
    current_user.update(tour_taken: true)
    respond_to do |format|
      format.json { render :json => { success: true }.to_json }
    end
  end

  # these routes for profile user
  def profile_banner
    render 'residents/contacts/profile_banner'
  end

  def profile
    @profile_btn = 'active'
    @comments = @user.shared_with_me(@user.comments).filtered_for(current_user, params[:filter])
    @comments = set_pagination @comments, Comment::USER_PER_PAGE
    load_more_at_bottom_respond_to @comments, html: 'residents/profiles/profile', partial: 'comments/timeline_comment'
  end

  def about
    @about_btn = 'active'
    render 'residents/profiles/about'
  end

  def photos
    @photos_btn = 'active'
    render 'residents/profiles/photos'
  end

  def settings
    @settings_btn = 'active'

    render 'residents/profiles/settings'
  end

  def set_password
    @user = current_user
    render 'users/forgot_password'
  end

  def update_profile
    if @user.update(user_edit_params)
      redirect_to user_about_path(@user)
    else
      render 'residents/profiles/about'
    end
  end

  def update_settings
    @user.update_settings params.require(:setting).permit(*(@user.settings_notifications + @user.settings_profile))
    redirect_to user_settings_path(@user)
  end

  def update_logo
    logo = params[:destroy] ? nil : params[:user][:logo]
    @user.update logo: logo
    redirect_to :back
  end

  

  def update_password
    
    if @user.change_password == true
      
      if @user.update_with_password_first password_change_params
        @user.change_password = false
        @user.password = params['password']
        @user.save
        bypass_sign_in(@user)
        flash[:notice] = t('devise.password_changed')
        redirect_to root_path()
      
      end
    else
      if @user.update_with_password password_params
        bypass_sign_in(@user)
        flash[:notice] = t('devise.password_changed')
      end
    end
  end

  def leave_community
    @user.leave_community(leave_community_params)
    flash[:notice] = "You left the community" if !@user.errors.any?
  end

  def toggle_report
    #toggle_mark_for @user, 'reported'
    @user.toggle_mark current_user, 'reported'
    status = @user.marked?(current_user, 'reported') ? 'reported' : 'unreported'
    flash[:notice] = "User has been #{status}"
    redirect_to :back
  end

  def change_password
    #@user  = current_user
  end

  def export
    @users = current_user.contacts(params[:company],params[:building])
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  def delete_users
    require 'csv'    
    csv_text = File.read('Eliminar_usuarios_DB.csv')
    csv = CSV.parse(csv_text, :headers => true)
    
    csv.each do |single|
      single_hash = single.to_hash
      user  = User.find_by email: single_hash['EmailPropietario']
      unless user.blank?
        user.destroy
      end
    end
    

  end

private

  def user_edit_params
    params
      .require(:user)
      .permit(:email, :first_name, :last_name, :accountable_type, :accountable_id, :logo, :remove_logo, :locale, :role,
        contact_details_attributes: permitted_contact_details_attributes,
        images_attributes: permitted_images_attributes
      )
  end

  def permitted_contact_details_attributes
    %i(id apartment_numbers_string phone emergency_contact_name emergency_contact_phone user_type 
      move_in_date sex work education from birth_day birth_year mobile_phone garage locker
      links relationship hometown)
  end

  def permitted_images_attributes
    %i(id image home _destroy)
  end

  def business_params
    params.require(:business).permit(:name, :namespace, :description, :phone, :extension, :email, :opening_hours,
      :location, :website,:country, :region, :city, :address, :zip, :confirm_legal_representation
    ).merge!(user_id: current_user.id)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
  
  def password_change_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_company
  	@company = Company.find_by namespace: (params[:namespace] || params[:company_namespace])
  end

  def leave_community_params
    params.permit(:id, :password, :accepted)
  end

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
    @administrative_roles = [{:id => 'administrator', :name => t('roles.administrator')},{:id => 'collaborator', :name => t('roles.collaborator')}]
  end



end
