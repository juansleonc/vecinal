class CustomDevise::RegistrationsController < Devise::RegistrationsController
  before_action :get_members_roles, only: [:create_users]
  before_action :get_administrative_roles, only: [:create_users]
  before_action :check_namespace_exists, only: [:new, :create]
  
  before_action :set_accountable, only: [:new, :create, :guests_users]
  # GET /resource/sign_up
  def create_users
    if can?(:create_user, current_user)
      params[:order] ||= 'asc'
      @submenu_item = 'invites'
      @submenu_title = t 'invites.invites'

      @action_for_search = search_users_path(query: params[:query], responsible: params[:responsible], order: params[:order], b: params[:b], c: params[:c])

      @contacts = current_user.contacts_off
      @contacts_by_accountable = current_user.contacts_by_accountable_off
      
      @total_invites = 0
      @contacts_by_accountable.each do |invites|
        invites.each do |invite, value|
          @total_invites += value
        end
      end
      
      @param_building = params[:b] if params[:b].present?
      @param_company = params[:c] if params[:c].present?

      if @param_building
        @contacts = @contacts.where('accountable_type = ? AND accountable_id = ?',
            'Building', @param_building.to_i).where(accepted: true)
      end

      if @param_company
        @contacts = @contacts.where('accountable_type = ? AND accountable_id = ?',
        'Company', @param_company.to_i, 
        ).where(accepted: true)
      end

      if params[:order] == 'last'
        @contacts = @contacts.order(:id => 'DESC')
      elsif params[:order] == 'oldest'
        @contacts = @contacts.order(:id => 'ASC')
      else
        @contacts = @contacts.order(:first_name => params[:order].to_sym)
      end

      @contacts = @contacts.paginate(page: params[:page], per_page: User::CONTACTS_PER_PAGE)

      @total = @contacts.count
      @order = %w[asc desc last oldest].include?(params[:order]) ? params[:order].to_sym : :desc
      build_resource
      yield resource if block_given?
      
      respond_with resource
    else
      redirect_to root_path
    end
  end

  def search
    params[:order] ||= 'asc'
    @contacts_by_accountable = current_user.contacts_by_accountable_off
      
    @total_invites = 0
    @contacts_by_accountable.each do |invites|
      invites.each do |invite, value|
        @total_invites += value
      end
    end
    @contacts = current_user.contacts_off.search_by(params[:query])
    
    
    if params[:b].present?
      @contacts = @contacts.where(accountable_id: params[:b])
    end

    if params[:order] == 'last'
      @contacts = @contacts.order(:id => 'DESC')
      
    elsif params[:order] == 'oldest'
      @contacts = @contacts.order(:id => 'ASC')
    else
      @contacts = @contacts.order(:first_name => params[:order].to_sym)
    end
    @contacts = @contacts.paginate(page: params[:page], per_page: User::CONTACTS_PER_PAGE)
    
    @total = 0
    
    load_more_at_bottom_respond_to @contacts, html: 'devise/registrations/search_results', partial: 'devise/registrations/contact'
  end

  def guests_users
    
    invites = Invite.all
   
    invites.each do |invite|
      build_resource({
        :email => invite.email,
        :role => invite.role,
        :password => invite.email,
        #:password_confirmation => "111111",
        :accepted => true,
        :locale => 'en',
        :accountable_type => invite.accountable_type,
        :accountable_id => invite.accountable_id,
        :first_name => invite.first_name,
        :last_name => invite.last_name
      })
      if resource.valid?
        resource.save!
      end
      yield resource if block_given?
    end
    redirect_to create_users_url
  end

  # POST /resource
  def create
    if params['import_type'] == 'bulk-import' 
      user = params[:user]
      params[:bulk_import].split("\n").each do |row|
        attrs = row.split("\t").map { |p| p.strip }
        
        user = user.merge(first_name: attrs[0], last_name: attrs[1], email: attrs[2], apartment_numbers: attrs[3])
        
        
        
        build_resource({
          :email => user[:email],
          :role => user[:role],
          :password => Devise.friendly_token.first(8),
          #:password_confirmation => "111111",
          :accepted => true,
          :locale => user[:locale],
          :accountable_type => user[:accountable_type],
          :accountable_id => user[:accountable_id],
          :first_name => user[:first_name],
          :last_name => user[:last_name]
          #:apartment_numbers => user[:apartment_numbers_string]
        })
        
        
        if params['is_admin'] == 'true'
          resource.accepted = true
          resource.change_password = true
          resource.create_by_admin = current_user.id
          resource.save
        end
        
        if resource.role.blank?
          resource.role = params[:user][:role]
        end

        
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
          else
            expire_data_after_sign_in!
            if params['is_admin'] != 'true'
              
            else
              if resource.role == 'administrator'
                resource.settings.create name: 'who_can_see_your_name', value: 'public'
                resource.settings.create name: 'who_can_see_your_email', value: 'public'
                resource.settings.create name: 'who_can_see_my_profile', value: 'public'
                resource.settings.create name: 'who_can_post_timeline', value: 'management_only'
                resource.settings.create name: 'who_can_see_others_posts', value: 'management_only'
              end
              if params['is_admin'] == 'true'
                
                resource.contact_details.apartment_numbers = [attrs[3]]
                resource.save
              end
            end
          end
        else
          if params['is_admin'] != 'true'
            clean_up_passwords resource
            set_minimum_password_length
          else
            set_flash_message! :warning, 'use_email_way'
          end
          
        end
      end
      
      
      redirect_to create_users_path()
    else
      build_resource(sign_up_params)


      #puts resource.to_json
      #abort '======='

      if params['is_admin'] == 'true'
        resource.create_by_admin = current_user.id
        resource.accepted = true
        resource.change_password = true
      end

      if resource.role.blank?
        resource.role = params[:user][:role]
      end

      
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          if params['is_admin'] != 'true'
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          else
            if resource.role == 'administrator'
              resource.settings.create name: 'who_can_see_your_name', value: 'public'
              resource.settings.create name: 'who_can_see_your_email', value: 'public'
              resource.settings.create name: 'who_can_see_my_profile', value: 'public'
              resource.settings.create name: 'who_can_post_timeline', value: 'management_only'
              resource.settings.create name: 'who_can_see_others_posts', value: 'management_only'
            end
            if params['is_admin'] == 'true'
                
              resource.contact_details.apartment_numbers = [params[:apartment_numbers]]
              resource.save
            end
            respond_with resource, location: create_users_url
          end
        end
      else
        
        if params['is_admin'] != 'true'
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        else
          user = User.where(role: nil, accountable_type: nil, accountable_id: nil, accepted: false).find_by email: params[:user][:email]
          
          if user
            user.update_columns role: params[:user][:role], accountable_type: params[:user][:accountable_type], accountable_id: params[:user][:accountable_id], accepted: true
            respond_with user, location: create_users_url
          else
            set_flash_message! :warning, 'use_email_way'
            redirect_to create_users_url
          end
          
        end
        
      end
    end


    
    
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
    @administrative_roles = [{:id => 'administrator', :name => t('roles.administrator')},{:id => 'collaborator', :name => t('roles.collaborator')}]
  end

protected

  def check_namespace_exists
    if params[:namespace].present?
      redirect_to welcome_path unless Company.find_by_namespace(params[:namespace])
    end
  end

  def set_accountable
    if params[:user].present? and ['Building', 'Company'].include?(params[:user][:accountable_type]) and params[:user][:accountable_id].present?
      @accountable = params[:user][:accountable_type].constantize.find_by_id(params[:user][:accountable_id])
    elsif current_building
      @accountable = current_building
    elsif params[:namespace].present?
      @accountable = Company.find_by_namespace(params[:namespace])
    end
  end

  def after_update_path_for(resource)
    user_dashboard
  end

  def after_inactive_sign_up_path_for(resource)
    welcome_path(user: resource.id)
  end

  def require_no_authentication
    if params['is_admin'] != 'true'
      assert_is_devise_resource!
      return unless is_navigational_format?
      no_input = devise_mapping.no_input_strategies

      authenticated = if no_input.present?
        args = no_input.dup.push scope: resource_name
        warden.authenticate?(*args)
      else
        warden.authenticated?(resource_name)
      end

      if authenticated && resource = warden.user(resource_name)
        flash[:alert] = I18n.t("devise.failure.already_authenticated")
        redirect_to after_sign_in_path_for(resource)
      end
    end
  end

end