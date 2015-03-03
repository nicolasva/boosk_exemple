BoosketShop::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true
  if defined? Uglifier
    config.assets.js_compressor = Uglifier.new(
      :toplevel => true,
      :beautify => false,
      :copyright => false,
      :beautify_options => {:indent_level => 0, :space_colon => false}
    )
  end

  # Don't fallback to assets pipeline if a precompiled asset is missed
  # config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store, "shops.boosket.com"

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( backend/plan.js backend/wizard.js mobile/redirect.js)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  BOOSKETSHOPS = YAML.load_file("#{Rails.root.to_s}/config/boosketshops.yml")[Rails.env]
  OGONE = YAML.load_file("#{Rails.root.to_s}/config/ogone.yml")[Rails.env]
  DEVISES = YAML.load_file("#{Rails.root.to_s}/config/devises.yml")

  PayPal::Recurring.configure do |config|
    config.sandbox = true
    config.username = "dev_1347289140_biz_api1.boosket.com"
    config.password = "1347289183"
    config.signature = "AId-oC7Ze.OQjDwW1GgTjvqGcMmNAYR-ZuA5J1MEbePdtAJh2L2aJc8p"
  end

  # fix rack cache
  config.action_dispatch.rack_cache = nil

  config.action_mailer.default_url_options = { :host => "shops.boosket.com" }
  config.action_mailer.asset_host = "http://shops.boosket.com"

  config.middleware.use ExceptionNotifier,
    :email_prefix => "[BoosketShops::ExceptionNotifier] ",
    :sender_address => %{ "Boosket Shops Exception Notifier" <noreply@boosket.com> },
    :exception_recipients => %w{ dev@boosket.com }

end
