set :application, 'torrito'

set :scm, :git
set :repository,  'git://github.com/suki-git/Torrito.git'
set :branch, 'master'
set :deploy_via, :remote_cache

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "~/#{application}"

role :web, 'relax.fiit.stuba.sk'                          # Your HTTP server, Apache/etc
role :app, 'relax.fiit.stuba.sk'                          # This may be the same as your `Web` server
role :db,  'relax.fiit.stuba.sk', :primary => true        # This is where Rails migrations will run

set :user, 'sukenik'
set :use_sudo, false

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

#whenever
after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  #desc "Update the crontab file"
  #task :update_crontab, :roles => :db do
  #  run "cd ~/torrito/current && whenever --write-crontab #{application}"
  #end

  desc "Restart application"
  task :restart do
      run "touch #{current_path}/tmp/restart.txt"
  end
end
