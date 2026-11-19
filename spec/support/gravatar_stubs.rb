# frozen_string_literal: true

# User profile pages read the Gravatar profile (see User#gravatar). Specs that render
# them answer with an empty profile instead of reaching gravatar.com.
module GravatarStubs
  def stub_gravatar_profiles
    stub_request(:get, %r{\Ahttps://(www\.)?gravatar\.com/[0-9a-f]{32}\.json\z})
      .to_return(status: 200, body: { 'entry' => [{}] }.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end

RSpec.configure do |config|
  config.include GravatarStubs
end
