#========================
#CONFIG
#========================
set :application, "liftrapp.com"
set :scm, :git
set :git_enable_submodules, 1
set :repository, "git@github.com:csamuel/sinatra-template.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
set :stage, :production
set :user, "csamuel"
set :use_sudo, false
set :runner, "www-data"
set :deploy_to, "/var/www/#{application}"
set :app_server, :passenger
set :domain, "liftrapp.com"

set :s3_bucket, "mc-assets"

#========================
#ROLES
#========================
role :app, domain
role :web, domain
role :db, domain, :primary => true
#========================
#CUSTOM
#========================
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  task :stop, :roles => :app do
    # Do nothing.
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :s3 do
  desc "Sync s3 assets"
  task :sync_public do
    run "s3sync -r -v --exclude=\".*\" ./public/ #{s3_bucket}:"
  end
end

before "deploy:symlink", "s3:sync_public"