# frozen_string_literal: true

require 'spec_helper'

# Make sure that https://nvd.nist.gov/vuln/detail/CVE-2015-9284 is mitigated
describe 'CVE-2015-9284', type: :request do
  describe 'GET /auth/:provider' do
    it do
      get '/users/auth/github'
      expect(response).not_to have_http_status(:redirect)
    end
  end

  describe 'POST /auth/:provider without CSRF token' do
    before do
      @allow_forgery_protection = ActionController::Base.allow_forgery_protection
      ActionController::Base.allow_forgery_protection = true
    end

    after do
      ActionController::Base.allow_forgery_protection = @allow_forgery_protection
    end

    it do
      expect do
        post '/users/auth/github'
      end.to raise_error(ActionController::InvalidAuthenticityToken)
    end
  end
end
