# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails'
# Only the frameworks the application uses. Active Storage, Action Mailbox,
# Action Text and Action Cable are not loaded, so their routes and endpoints
# do not exist.
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# load config.yaml preprocessed
CONFIG ||= YAML.safe_load(ERB.new(File.read('config/config.yml')).result)

module T4c
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/lib]
    config.assets.initialize_on_precompile = true
    # Only takes effect where force_ssl is on (production). The health probe must
    # answer over plain http, so it is excluded from the redirect. HSTS covers this
    # host only, not its subdomains.
    config.ssl_options = {
      redirect: { exclude: ->(request) { request.path == '/up' } },
      hsts: { subdomains: false, expires: 1.year }
    }
    config.available_locales = %w[en es fr nl ru pl hr de ro ko id ja pt my cn hk]
  end
end

I18n.enforce_available_locales = false
