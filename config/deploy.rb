require 'capistrano/ext/multistage'

set :application, "AuraBiz"
set :scm, :git
set :repository,  "git@github.com:auranet/aura-biz.git"
set :use_sudo, false
set :deploy_to, "/var/www/virtual/#{application}"
set :stages, %w(production)

# Override server control for passenger
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
