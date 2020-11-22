# frozen_string_literal: true

# Load the blacklist.
BLACKLIST ||= Blacklist.new(YAML.load_file('config/blacklist.yml'))
