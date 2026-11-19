# frozen_string_literal: true

require 'spec_helper'

describe 'Parameter filtering in logs', type: :request do
  let(:filter) { ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters) }

  it 'logs the login token of /users/login as [FILTERED]' do
    logged = nil
    callback = ->(*args) { logged = ActiveSupport::Notifications::Event.new(*args).payload[:params] }
    ActiveSupport::Notifications.subscribed(callback, 'process_action.action_controller') do
      get '/users/login', params: { token: 'abc' }
    end

    expect(logged['token']).to eq('[FILTERED]')
    expect(filter.filter('token' => 'abc')).to eq('token' => '[FILTERED]')
  end

  it 'filters every token and secret parameter by partial match' do
    params = { 'login_token' => 'a', 'confirmation_token' => 'b', 'reset_password_token' => 'c',
               'client_secret' => 'd', 'password' => 'e' }
    expect(filter.filter(params).values).to all(eq('[FILTERED]'))
  end

  it 'leaves email visible' do
    expect(filter.filter('email' => 'someone@example.com')).to eq('email' => 'someone@example.com')
  end
end
