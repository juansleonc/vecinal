require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CondoMedia
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      "<div class=\"has-error\">#{html_tag}</div>".html_safe
    }

    config.action_mailer.default_url_options = { host: Rails.application.secrets.app_domain, protocol: :https, subdomain: :www }
    config.action_mailer.asset_host = 'https://www.' + Rails.application.secrets.app_domain

    config.to_prepare do
      Devise::SessionsController.layout "devise"
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "devise" }
      Devise::ConfirmationsController.layout "devise"
      Devise::PasswordsController.layout "devise"
    end

    config.i18n.available_locales = [:en, :fr, :es]

    config.active_record.raise_in_transactional_callbacks = true

    config.to_prepare do
      Devise::Mailer.layout 'mailer'
    end

  end

end
