unicorn_env = ENV["UNICORN_ENV"] || "stage"
worker_processes 4
preload_app true
timeout 120
rails_root  = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'shared'))

if unicorn_env == "master"
  listen "/tmp/shops.boosket.com.sock", :backlog => 4096
  pid "/u/apps/boosket-shop/shared/pids/unicorn.pid"
  stderr_path "/u/apps/boosket-shop/shared/log/unicorn-stderr.log"
  stdout_path "/u/apps/boosket-shop/shared/log/unicorn.stdout.log"
elsif unicorn_env == "stage"
  listen "/tmp/shop.stage.boosket.com.sock", :backlog => 4096
  pid "/u/apps/boosket-shop/shared/pids/unicorn.pid"
  stderr_path "/u/apps/boosket-shop/shared/log/unicorn-stderr.log"
  stdout_path "/u/apps/boosket-shop/shared/log/unicorn.stdout.log"
else
  listen      3000
  pid         "tmp/pids/unicorn.pid"
  stderr_path "log/unicorn-stderr.log"
  stdout_path "log/unicorn.stdout.log"
end

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  old_pid = rails_root + "/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
     begin
       Process.kill("QUIT", File.read(old_pid).to_i)
     rescue Errno::ENOENT, Errno::ESRCH
       # nok
     end
   end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
  worker.user("boosket", "boosket") if Process.euid == 0
end
