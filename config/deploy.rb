set :application, "avidmanager.com"
set :repository,  "http://svn.avidmanager.com/avid-home/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :web, "avidmanager.com"
role :app, "avidmanager.com"
role :db,  "avidmanager.com", :primary => true

ssh_options[:port] = 25552
#ssh_options[:verbose] = :debug
ssh_options[:username] = "webmaster"
ssh_options[:host_key] = "ssh-rsa"

#set :deploy_to, "/home/webmaster/avidmanager.com"
set :deploy_to, "/home/webmaster/avid/avid-home"
set :asset_root, "/home/webmaster/avid/avid-assets"
set :shared_root, "/home/webmaster/avid/avid-shared"

set :user, "webmaster"
set :admin_runner, "webmaster"
set :runner, "webmaster"
set :checkout, "export"

set :keep_releases, 3

desc "Symlink asset dirs so we can use Rails asset caching with asset hosts"
task :symlink_assets do
  run "ln -s #{asset_root}/images #{release_path}/public/images"
  run "ln -s #{asset_root}/javascripts #{release_path}/public/javascripts"
  run "ln -s #{asset_root}/stylesheets #{release_path}/public/stylesheets"
end

desc "symlink shared code to the deploy dir so that the shared paths work for all env"
task :symlink_shared do
  run "ln -s #{shared_root} #{release_path}/avid-shared"
  run "ln -s #{shared_root}/lib #{release_path}/lib"
  run "ln -s #{shared_root}/db #{release_path}/db"
end

desc "symlink shared code to the deploy dir so that the shared paths work for all env"
task :update_shared_assets do
  run "svn update"
end

after "deploy:update_code", "update_shared_assets"
after "deploy:update_code", "symlink_assets"
after "deploy:update_code", "symlink_shared"

namespace :deploy do
  task :avid do
    update
    web.disable
    sleep 2
    migrate
    restart
    web.enable
    cleanup
  end
  
  task :avid_quick do
    update
    web.disable
    sleep 2
    restart
    web.enable
    cleanup
  end
  
  task :restart, :roles=>:app do
    #sudo "/etc/init.d/monit stop"
    #sleep 3
    #sudo "/etc/init.d/thin restart"
    #sleep 4
    sudo "/etc/init.d/apache2 restart"
    sleep 9
    sudo "/etc/init.d/memcached restart"
    sleep 5
    #sudo "/etc/init.d/monit start"
  end
  
  namespace :web do
    task :allow_admin do
      sudo "cp /etc/apache2/sites-available/default-no-maintenance /etc/apache2/sites-available/default"
      sudo "/etc/init.d/apache2 restart"
    end
    
    task :no_admin do
      sudo "cp /etc/apache2/sites-available/default-with-maintenance /etc/apache2/sites-available/default"
      sudo "/etc/init.d/apache2 restart"
    end
  end
  #task :finalize_update, :except => { :no_release => true } do
    #sudo "ln -s #{release_path}/config/production/avid.yml /etc/thin/avid.yml"
    #sudo "ln -s #{release_path}/config/production/nginx.conf /etc/nginx/nginx.conf"
    #sudo "ln -s #{release_path}/config/production/avid.conf /etc/nginx/avid.conf"
  #end
end
