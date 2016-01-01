workers 3 #Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = 5 #Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count
daemonize false

preload_app!

rackup      DefaultRackup
if RUBY_PLATFORM =~ /darwin/
  port        ENV['PORT']     || 3000
  environment ENV['RACK_ENV'] || 'development'
  pidfile 'tmp/pids/puma.pid'
  state_path 'tmp/pids/puma.state'
else
  environment ENV['RACK_ENV'] || 'production'
  bind 'unix:///home/mapwarper/puma.sock'
  pidfile "/home/mapwarper/puma.pid"
  stdout_redirect '/srv/mapwarper/log/production.log', '/srv/mapwarper/log/production.log', true
  state_path '/home/mapwarper/puma.state'
end


on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
