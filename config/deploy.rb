require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'sidekiq/capistrano'

default_run_options[:pty] = true
set :use_sudo, false

set :application, 'boosket-shop-wheezy'
set :user, 'boosket'
set :stages, %w(production staging)
set :default_stage, 'staging'
set :deploy_to, "/data/webapps/com/boosket/#{application}"

set :runner, user
set :rvm_ruby_string, "ruby-1.9.3@#{application}"
set :rvm_type, :user

set :scm, :git
set :scm_username, user
set :repository, "git@albundy.boosket.com:#{application}.git"
set :scm_verbose,  false
set :deploy_env, 'production'

set :unicorn_bin, 'bundle exec unicorn_rails'
set :unicorn_pid, "/u/apps/boosket-shop/shared/pids/unicorn.pid"

set :sidekiq_role, :sidekiq

namespace :unicorn do
  desc 'Start unicorn'
  task :start, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path};UNICORN_ENV=#{branch} #{unicorn_bin} -c #{current_path}/config/unicorn.rb -E #{rails_env} -D"
  end
  desc 'Stop unicorn'
  task :stop, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path};kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc 'Restart unicorn'
  task :restart, :roles => :app, :except => {:no_release => true} do
    unicorn.stop
    unicorn.start
  end
end


namespace :uploads do
  desc "Create the symlink to uploads"
  task :create_symlink, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

namespace :cache do
  desc 'Clear cache after deployment'
  task :clear, :roles => :app do
    run "cd #{current_path} && bundle exec rake cache:clear RAILS_ENV=#{rails_env}"
  end
end

after 'deploy:start', 'unicorn:start'
after 'deploy:stop', 'unicorn:stop'
after 'deploy:restart', 'unicorn:restart'
after 'deploy:finalize_update', 'uploads:create_symlink'
