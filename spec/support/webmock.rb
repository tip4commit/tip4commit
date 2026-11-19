# frozen_string_literal: true

require 'webmock/rspec'

# Older specs still reach the network (e.g. gravatar from user views), so real connections stay
# allowed by default.
WebMock.allow_net_connect!
