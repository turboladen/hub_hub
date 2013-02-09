require 'bundler/capistrano'

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :whenever_command, "bundle exec whenever"
#set :whenever_environment, defer { stage }
require 'whenever/capistrano'

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

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

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

task :set_log_permissions do
  production_log = "#{shared_path}/log/production.log"

  if remote_file_exists? production_log
    run "chmod 0666 #{production_log}"
  end
end

task :database_file_to_shared do
  database_file = "#{shared_path}/database.yml"

  if remote_file_exists? database_file
    run "ln -s #{database_file} #{current_path}/config/database.yml"
  else
    run "cp #{current_path}/config/database.yml.sample #{database_file}"
    run "ln -s #{database_file} #{current_path}/config/database.yml"
  end
end

after "deploy", :set_log_permissions
after "deploy", :database_file_to_shared

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "Tail logs"
task :tail, :roles => :app do
  run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end
