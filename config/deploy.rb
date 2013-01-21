require 'bundler/capistrano'

set :user, "deploy"
set :domain, 'chat.mindhub.org'
set :application, "mindhub"

set :repository,  "git://github.com/turboladen/hub_hub.git"
set :deploy_to, "/var/www/#{domain}"

set :deploy_via, :remote_cache
set :scm, :git
set :scm_verbose, true
set :use_sudo, false
set :rails_env, 'production'

# For rbenv
set :bundle_flags, "--deployment --binstubs"
set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
}

#default_run_options[:pty] = true

server "chat.mindhub.org", :app, :web, :db, primary: true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

task :setup_deploy_to do
  unless remote_file_exists?(deploy_to)
    sudo "mkdir #{deploy_to}", pty: true
    sudo "chown deploy:deploy #{deploy_to}", pty: true
  end
end

before "deploy:setup", :setup_deploy_to

#------------------------------------------------------
#	Passenger
namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"

desc "Tail logs"
task :tail, :roles => :app do
  run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end
