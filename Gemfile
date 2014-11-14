source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails',           '4.0.2'
gem 'mysql2',                      group: :production
gem 'sass-rails',      '~> 4.0.0'
gem 'haml-rails',      '~> 0.5.3'
gem 'less-rails',      '~> 2.4.2'
gem 'kaminari',        '~> 0.15.0'
gem 'uglifier',        '>= 1.3.0'
gem 'coffee-rails',    '~> 4.0.0'
gem 'therubyracer',    '~> 0.12.0', platforms: :ruby
gem 'jquery-rails',    '~> 3.0.4'
gem 'turbolinks',      '~> 2.2.0'
gem 'jquery-turbolinks'
gem 'jbuilder',        '~> 1.5.3'
gem 'airbrake',        '~> 3.1.15'
gem 'devise',          '~> 3.2.2'
gem 'omniauth',        '~> 1.1.4'
gem 'omniauth-github', github: 'alexandrz/omniauth-github', branch: 'provide_emails'
gem 'octokit',         '~> 2.7.0'
gem 'sawyer',          '~> 0.5.2'
gem 'twitter_bootstrap_form_for', github: 'stouset/twitter_bootstrap_form_for'
gem 'twitter-bootstrap-rails',    github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'
gem 'bootstrap_form', github: 'bootstrap-ruby/rails-bootstrap-forms'
gem 'sdoc', group: :doc, require: false
gem 'cancancan'
gem 'dusen'
gem 'render_csv'
gem 'demoji'
gem 'acts_as_paranoid', github: 'ActsAsParanoid/acts_as_paranoid'

gem "http_accept_language"
gem 'rails-i18n'
gem "i18n-js"
gem 'kaminari-i18n'
gem 'devise-i18n'

group :development do
  gem 'capistrano',         '~> 3.0.1'
  gem 'capistrano-rvm',     '~> 0.1.0', github: 'capistrano/rvm'
  gem 'capistrano-bundler', '>= 1.1.0'
  gem 'capistrano-rails',   '~> 1.1.0'
  gem 'debugger',           '~> 1.6.5'
end

group :development, :test do
  gem 'sqlite3',            '~> 1.3.8'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem 'rspec-rails',        '~> 3.0.0.beta'
end

group :test do
  gem 'simplecov'
  gem 'shoulda-matchers',   '~> 2.5.0'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end
