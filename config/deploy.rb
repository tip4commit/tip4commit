# frozen_string_literal: true

set :application, 't4c'
set :repo_url, 'git@github.com:tip4commit/tip4commit.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/apps/t4c'

set :rvm_type, :user
set :rvm_ruby_version, '2.6.6'
set :rvm_custom_path, '~/.rvm'

set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w[config/database.yml config/config.yml]
set :linked_dirs, %w[log tmp]

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
end
