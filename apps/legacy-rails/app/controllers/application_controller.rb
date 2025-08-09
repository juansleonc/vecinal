class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :check_subdomain
  before_action :authenticate_user!, unless: :skip_user_authentication
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :change_password
  before_action :set_user_time_zone, :if => :current_user

  helper_method :current_user
  helper_method :current_user_contacts
  helper_method :current_building
  helper_method :user_dashboard
  helper_method :user_notifications_manager

  def current_user
    super || current_admin_user
  end

  def current_user_contacts
    @current_user_contacts ||= current_user.contacts
  end

  def current_building
    @current_building ||= Building.find_by_subdomain(request.subdomains.first)
  end

  def user_dashboard
    return rails_admin_path if current_admin_user
    if current_user and User::ROLES.include?(current_user.role) && current_user.accountable.present?
      if current_user.accepted?
        news_feed_path
      else
        finish_registration_buildings_path
      end
    elsif user_signed_in?
      finish_registration_buildings_path
    else
      root_url(subdomain: 'www')
    end
  end

protected

  def check_registration_finished
    if current_user.present? && current_user.class.name == 'User'
      if !(current_user.accountable.present? && User::ROLES.include?(current_user.role))
        redirect_to finish_registration_roles_path
      elsif !current_user.accepted?
        redirect_to finish_registration_buildings_path
      end
    end
  end

  def after_sign_in_path_for(resource)
    if params[:invite] && invite = Invite.find_by_id(params[:invite])
      accept_by_user_invite_path invite
    else
      user_dashboard
    end
  end

  def check_subdomain
    subdomain = request.subdomains.first
    unless subdomain == 'www' or (subdomain.present? and Building.find_by_subdomain(subdomain).present?)
      return redirect_to user_dashboard
    end
  end

  def skip_user_authentication
    devise_controller? or self.class.parent == RailsAdmin
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to user_dashboard, flash: {error: exception.message}
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:first_name, :last_name, :accountable_type, :accountable_id, :locale, :invite_id]
  end

  # We use this to persist images across form redisplays
  def images_processed_params(model_params)
    processed_params = model_params
    @saved_images = []
    (processed_params[:images_attributes] || []).each do |key, image|
      @saved_images << image if image[:id].present?
      processed_params[:images_attributes].delete(key) if (image[:id].present? or ["1", "true"].include?(image[:_destroy]))
    end
    return processed_params
  end

  # We use this to persist images across form redisplays
  def process_images(model_object, saved)
    @saved_images.each do |image_hash|
      image = Image.find(image_hash[:id])
      if ["1", "true"].include?(image_hash[:_destroy])
        image.destroy
      else
        image_hash.delete(:_destroy)
        image.update_attributes(image_hash.merge!(imageable_id: saved ? model_object.id : nil))
        model_object.images << image unless (saved or image.destroyed?)
      end
    end
    model_object.reload if saved
    return model_object
  end

  def set_locale
    current_locale = if current_user
      current_user.is_a?(AdminUser) ? :en : current_user.locale
    elsif session[:lang]
      session[:lang]
    elsif request.env['HTTP_ACCEPT_LANGUAGE'].present?
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    else
      ''
    end
    I18n.locale = CM_LOCALES.include?(current_locale.to_s) ? current_locale : I18n.default_locale
  end

  def registration_finished?
    current_user.present? and !devise_controller? and request.path != '/change_language'
  end

  def set_pagination(objects, limit, pag_params={})
    pag_params = {order_by: :updated_at}.merge pag_params
    @page = params[:page] && params[:page].to_i > 0 ? params[:page].to_i : 0
    @order = %w[asc desc].include?(params[:order]) ? params[:order].to_sym : :desc
    @offset = @page * limit
    @total = objects.size
    @limit = limit
    company = params[:c]
    building = params[:b]
    query = params[:query].present? ? "&query=#{params[:query]}" : ''
    @next_path = "#{request.path}?page=#{@page + 1}&order=#@order#{query}&c=#{company}&b=#{building}".to_s if @offset + @limit < @total

    if @next_path
      @next_path += "&filter="
      @next_path += params.has_key?(:filter) ? params[:filter] : Date.current.strftime('%Y/%m')
      @next_path += "&building=#{params[:building].to_s}" if params.has_key? :building
    end
    
    objects.order(pag_params[:order_by] => @order).limit(@limit).offset(@offset)
  end

  def load_more_at_bottom_respond_to(model_objects, options = {})
    respond_to do |format|
      format.html {
        render options[:html] if options.has_key?(:html)
      }
      format.js {
        @model_objects = model_objects
        @partial = options[:partial]
        render 'shared/load_more_at_bottom'
      }
      format.json { 
        render json: options[:json] if options.has_key?(:json)
      }
    end
  end

  def user_notifications_manager
    @notificator ||= UserNotificationsManager.new(current_user)
  end

private

  def set_user_time_zone
    if user_signed_in?
      if current_user.accountable.country == 'Colombia'
        Time.zone = 'Bogota'
      end
    end
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_user, request.remote_ip)
  end

  def change_password
    if current_user
      if current_user.change_password == true
        route_settings = request.original_url.index('users/change_password')
        
        
        if current_user
          if route_settings == nil
              flash[:notice] = t('general.change_password')
              redirect_to change_password_path      
          end
        end
      end
    end
  end

end
