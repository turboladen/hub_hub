set :application, "mindhub"
set :repository,  "git://github.com/turboladen/hub_hub.git"
set :scp, :git
set :deploy_to, "/var/www"
set :user, "deploy"

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
