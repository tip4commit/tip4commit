# frozen_string_literal: true

require 'vcr'

# Scenarios never reach the network: requests outside a cassette are refused, and
# cassettes are played back only (a missing or unmatched request fails the scenario).
WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.cassette_library_dir = 'features/cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = { record: :none }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
  t.tag '@vcr-ignore-params', use_scenario_name: true, match_requests_on: %i[method host path]
end
