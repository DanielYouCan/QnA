# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "QnA"
set :repo_url, "git@github.com:DanielYouCan/QnA.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'


# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", ".env.production"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

set :rvm1_map_bins, fetch(:rvm1_map_bins).to_a.concat(%w(sidekiq sidekiqctl))
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :sphinx do
  desc 'Index sphinx'
  task :index do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake ts:index"
        end
      end
    end
  end

  desc 'Start sphinx'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake ts:start"
        end
      end
    end
  end

  desc 'Stop sphinx'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake ts:stop"
        end
      end
    end
  end

  desc 'Restart sphinx'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake ts:restart"
        end
      end
    end
  end
end

after 'deploy:restart', 'sphinx:index'
after 'sphinx:index', 'sphinx:restart'
