require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, 'eshare-verify.mindpin.com'
set :deploy_to, '/web/2013/eshare-verify'
set :current_path, 'current'
set :repository, 'git://github.com/mindpin/eshare-verify.git'
set :branch, 'master'
set :user, 'root'

set :shared_paths, [
  'config/database.yml',
  'log',
  'deploy/sh/property.yaml'
]

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]

  queue! %[mkdir -p "#{deploy_to}/shared/deploy/sh"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/deploy/sh"]
  queue! %[touch "#{deploy_to}/shared/deploy/sh/property.yaml"]

  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
  queue  %[echo "-----> Be sure to edit 'shared/deploy/sh/property.yaml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue! "bundle"
    # invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    queue! "rake db:create RAILS_ENV=production"
    queue! "rake db:migrate RAILS_ENV=production"
    invoke :'rails:assets_precompile'

    to :launch do
      queue %[
        source /etc/profile
        ./deploy/sh/unicorn_eshare_verify.sh stop
        ./deploy/sh/unicorn_eshare_verify.sh start
      ]
    end
  end
end

desc "restart server"
task :restart => :environment do
  queue %[
    source /etc/profile
    cd #{deploy_to}/#{current_path}
    ./deploy/sh/unicorn_eshare_verify.sh stop
    ./deploy/sh/unicorn_eshare_verify.sh start
  ]
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
