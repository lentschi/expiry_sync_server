require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module ExpirySyncServer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.i18n.default_locale = :en
    config.i18n.available_locales = %w(de en es it)
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]

    config.locations = {allow_removing_share_after_inactivity_days: 30}

    # Will be overwritten by ApplicationController::set_api_version
    # if the respective header is passed by the client:
    config.api_version = 0

    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true

    # CORS config:
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins /.*/
        resource '*', headers: :any, credentials: true, methods: [:get, :post, :put, :delete, :options]
      end
    end
  end
end
