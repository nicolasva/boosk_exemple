namespace :cache do
  desc 'Clear cache'
  task :clear => :environment do
    ActionController::Base.cache_store.clear
  end
end
