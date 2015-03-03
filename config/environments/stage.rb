BoosketShop::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true

  config.assets.compress = true
  if defined? Uglifier
    config.assets.js_compressor = Uglifier.new(
      :toplevel => true,
      :beautify => false,
      :copyright => false,
      :beautify_options => {:indent_level => 0, :space_colon => false}
    )
  end

  config.assets.digest = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
  # config.cache_store = :mem_cache_store, "shops.boosket.com"
  config.assets.precompile += %w( backend/plan.js backend/wizard.js mobile/redirect.js)
  config.i18n.fallbacks = true
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

  config.action_dispatch.rack_cache = nil

  config.action_mailer.default_url_options = { :host => "shops.stage.boosket.com" }
  config.action_mailer.asset_host = "http://shops.stage.boosket.com"

end

