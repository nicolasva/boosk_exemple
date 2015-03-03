set :branch, 'master'
set :rails_env, 'production'
server 'shops.boosket.com', :app, :web, :db, :primary => true
role :sidekiq, 'shops.boosket.com'
