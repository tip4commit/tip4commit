# frozen_string_literal: true

# Load the blacklist once the application classes can be autoloaded.
Rails.application.config.to_prepare do
  BLACKLIST ||= Blacklist.new(YAML.load_file('config/blacklist.yml'))
end
