require 'mongrel_cluster/recipes'

# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "foodlab"
set :repository, "http://svn.corkboardinc.com/#{application}/trunk"

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, "foodlab.tv"
role :app, "foodlab.tv"
role :db,  "foodlab.tv", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/var/#{application}/rails" # defaults to "/u/apps/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
# set :user, "flippy"            # defaults to the currently logged in user
# set :scm, :darcs               # defaults to :subversion
# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :darcs, "/path/to/darcs"   # defaults to searching the PATH
# set :cvs, "/path/to/cvs"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway
set :checkout, 'export'          # don't need the .svn files

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 2222

task :before_symlink do
  on_rollback {}
  # add database.yml
  run "cp /var/#{application}/etc/database.yml #{release_path}/config/database.yml"
  # migrate
  run "cd #{release_path} && rake db:migrate RAILS_ENV=production"
end

task :after_update_code do
  # add ferret index
  run "ln -nfs #{shared_path}/index #{release_path}/index"
end


task :disable_web, :roles => :web do
  on_rollback { delete "#{shared_path}/system/maintenance.html" }
  
  maintenance = render("./app/views/layouts/maintenance.rhtml", 
                       :deadline => ENV['UNTIL'],
                       :reason => ENV['REASON'])
                       
  put maintenance, "#{shared_path}/system/maintenance.html", 
                   :mode => 0644
end