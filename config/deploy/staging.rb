set :branch, 'stage'
set :rails_env, 'stage'
server 'shops.stage.boosket.com', :app, :web, :db, :primary => true
role :sidekiq, 'shops.stage.boosket.com'
