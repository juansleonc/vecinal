class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  PROVIDER_NAMES = {facebook: 'Facebook', linkedin: 'Linkedin', google_oauth2: 'Google'}

  %w[facebook linkedin google_oauth2].each do |provider|
    define_method(provider) do
      @user = User.from_omniauth(request.env["omniauth.auth"], provider)

      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: PROVIDER_NAMES[provider.to_sym]) if is_navigational_format?
      else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join(', ')
      end

    end
  end

  def failure
    redirect_to new_user_registration_url
  end

end