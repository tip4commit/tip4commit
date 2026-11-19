# frozen_string_literal: true

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

# concurrent-ruby >= 1.3.5 no longer requires logger, which Rails 6.1 expects to be loaded.
require 'logger'
