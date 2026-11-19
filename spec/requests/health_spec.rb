# frozen_string_literal: true

require 'spec_helper'

describe 'Health check and SSL handling', type: :request do
  describe 'GET /up' do
    it 'returns ok' do
      get '/up'
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('ok')
    end
  end

  describe 'SSL redirect as configured for production' do
    # force_ssl is only enabled in production, so wrap the app in the same
    # middleware with the application-wide ssl_options.
    let(:app) { ActionDispatch::SSL.new(Rails.application, **Rails.application.config.ssl_options) }
    let(:session) { Rack::MockRequest.new(app) }

    it 'does not redirect when the proxy forwarded https' do
      response = session.get('/', 'HTTP_X_FORWARDED_PROTO' => 'https', 'HTTP_HOST' => 'example.com')
      expect(response.status).not_to be_between(300, 399)
    end

    it 'redirects http to https' do
      response = session.get('/', 'HTTP_X_FORWARDED_PROTO' => 'http', 'HTTP_HOST' => 'example.com')
      expect(response.status).to eq(301)
      expect(response.headers['Location']).to eq('https://example.com/')
    end

    it 'sends HSTS for this host only, for one year' do
      response = session.get('/', 'HTTP_X_FORWARDED_PROTO' => 'https', 'HTTP_HOST' => 'example.com')
      hsts = response.headers['Strict-Transport-Security']
      expect(hsts).to eq("max-age=#{1.year.to_i}")
      expect(hsts).not_to include('includeSubDomains')
    end

    it 'serves /up over plain http without redirecting' do
      response = session.get('/up', 'HTTP_X_FORWARDED_PROTO' => 'http', 'HTTP_HOST' => 'example.com')
      expect(response.status).to eq(200)
      expect(response.body).to eq('ok')
    end
  end

  describe 'production environment' do
    it 'forces ssl' do
      config = Rails.root.join('config/environments/production.rb').read
      expect(config).to match(/^\s*config\.force_ssl = true$/)
    end
  end
end
