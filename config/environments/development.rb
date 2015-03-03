BoosketShop::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  BOOSKETSHOPS = YAML.load_file("#{Rails.root.to_s}/config/boosketshops.yml")[Rails.env]
  OGONE = YAML.load_file("#{Rails.root.to_s}/config/ogone.yml")[Rails.env]
  DEVISES = YAML.load_file("#{Rails.root.to_s}/config/devises.yml")

  PayPal::Recurring.configure do |config|
    config.sandbox = true
    config.username = "dev_1347289140_biz_api1.boosket.com"
    config.password = "1347289183"
    config.signature = "AId-oC7Ze.OQjDwW1GgTjvqGcMmNAYR-ZuA5J1MEbePdtAJh2L2aJc8p"
  end

  config.assets.logger = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.action_mailer.asset_host = "http://localhost:3000"
  config.action_mailer.smtp_settings = { :address => "127.0.0.1", :port => 1025 }
  config.action_mailer.raise_delivery_errors = true

end