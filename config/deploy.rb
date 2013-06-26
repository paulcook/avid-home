require 'bundler/capistrano'

set :application, "avid-home"
set :repository,  "git@github.com:paulcook/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :use_sudo, false
default_run_options[:pty] = true

role :web, "198.211.114.209"
role :app, "198.211.114.209"
role :db,  "198.211.114.209", :primary => true

ssh_options[:port] = 25552
#ssh_options[:verbose] = :debug
ssh_options[:username] = "webapp"
ssh_options[:host_key] = "ssh-rsa"
set :ssh_options, { :forward_agent => true }

#set :deploy_to, "/home/webapp/avidmanager.com"
set :deploy_to, "/home/webapp/avid/#{application}"
set :asset_root, "/home/webapp/avid/avid-assets"
set :shared_root, "/home/webapp/avid/avid-shared"

set :user, "webapp"
set :admin_runner, "webapp"
set :runner, "webapp"
set :checkout, "export"

set :keep_releases, 3
set :bundle_flags, "--deployment"


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "symlink shared code to the deploy dir so that the shared paths work for all env"
  task :symlink_shared do
    run "ln -s #{shared_root} #{release_path}/avid-shared"
    run "ln -s #{shared_root}/lib #{release_path}/lib"
    run "ln -s #{shared_root}/db #{release_path}/db"
  end

  desc "Symlink asset dirs so we can use Rails asset caching with asset hosts"
  task :symlink_assets do
    run "ln -s #{asset_root}/images #{release_path}/public/images"
    run "ln -s #{asset_root}/javascripts #{release_path}/public/javascripts"
    run "ln -s #{asset_root}/stylesheets #{release_path}/public/stylesheets"
  end

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  after "deploy:finalize_update", "deploy:symlink_config"
  after "deploy:finalize_update", "deploy:symlink_shared"
  #after "deploy:finalize_update", "deploy:symlink_assets"

end
