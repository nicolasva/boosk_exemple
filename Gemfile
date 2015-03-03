source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.0'

gem 'mongoid', '3.0.1'
gem 'database_cleaner'

gem "bundler", "~> 1.2.3"

gem 'redis'
gem 'json'

gem 'guid'

gem 'haml'
gem 'slim'
gem 'jquery-rails', '2.1.4'
gem 'coffee-script'
gem 'ejs'

gem 'carmen', '1.0.0.beta2'

gem 'devise'
gem 'devise-encryptable'
gem 'devise_invitable', '~> 1.0.0'
gem "omniauth-facebook"

gem 'rest-graph'
gem 'rest-client'
gem 'em-http-request'

gem 'carrierwave', '~> 0.5.8'
gem 'rmagick'

gem 'paypal_adaptive'
gem 'paypal-recurring'

gem 'awesome_nested_set'

gem 'sidekiq', '~> 2.5.3'
gem 'sinatra'

gem "nokogiri", "~> 1.5.5"

gem 'workflow', '~> 0.8.1'

gem 'deep_cloneable', '~> 1.4.0'

gem 'kaminari', '~> 0.13.0'

gem 'sass-rails',   '~> 3.2.6'
gem 'compass-rails', '~> 1.0.3'

gem 'exception_notification', :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"

group :assets do
  gem 'execjs', '~> 1.2.13'
  gem 'therubyracer'
  gem 'compass-colors'
  gem 'sassy-buttons'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'mysql2', '0.3.10'
  gem 'unicorn'
  gem 'memcache-client', '~> 1.8.5'
end

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano-ext'
  gem 'mailcatcher'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'webmock', :require => nil
  gem 'turn', '0.8.2', :require => false
  gem 'faker'
end

group :development, :test do
  gem 'sqlite3'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-coffeescript'
  gem 'guard-rails-assets'
  gem 'guard-jasmine-headless-webkit'
  gem 'rspec-rails', '~> 2.11.4'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
end
