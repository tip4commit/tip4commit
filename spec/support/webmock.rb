# frozen_string_literal: true

require 'webmock/rspec'

# No spec reaches the network: stub every external request (see gravatar_stubs.rb).
WebMock.disable_net_connect!(allow_localhost: true)
