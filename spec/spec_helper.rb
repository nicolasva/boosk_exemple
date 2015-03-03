# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
#require 'helper_methods'
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
#include HelperMethods

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.order = 'random'
  config.mock_with :rspec
  config.include Devise::TestHelpers, :type => :controller
  config.include DeviseForm
  config.include FactoryGirl::Syntax::Methods
  config.before(:each) do
    I18n.locale = :en
  end

  config.before(:type => :controller) do
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'fr'
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    #DatabaseCleaner.orm = "active_record"
  end
 
  config.before(:each) do
    DatabaseCleaner.clean
    Preferences::Store.instance.persistence = false
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
   config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false


end

def user_first
  @user ||= User.first
end

def file_path( *paths )
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', *paths))
end

def public_path( *paths )
  File.expand_path(File.join(File.dirname(__FILE__), 'public', *paths))
end

def backend_url_root
  "http://shops.example.com"
end

def frontoffice_url_root
  "http://azerty.boosket-shop-wheezy.dev"
end