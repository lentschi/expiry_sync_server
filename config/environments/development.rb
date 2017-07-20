ExpirySyncServer::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { host: (ENV['EMAIL_LINK_HOST'].nil? ? 'localhost:3000' : ENV['EMAIL_LINK_HOST']) }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.secret_key_base = 'c5fc7721e07c546e0d0949d4059f8bb1e39f26a3be6b1d5ec03eff2629d8910ded026afdab2dedefcd9a7f57bf95034adcb19ba4ef8b0a8e76a1a1e0113a4295'
end
