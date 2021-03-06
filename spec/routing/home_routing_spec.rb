# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'routes for Home', type: :routing do
  it 'routes GET / to Home#index' do
    expect({ get: '/' }).to route_to(
      controller: 'home',
      action: 'index'
    )
  end

  it 'routes GET /users/999999/no-such-path to Home#index' do
    expect({ get: '/users/999999/no-such-path' }).to route_to(
      controller: 'home',
      action: 'index',
      path: 'users/999999/no-such-path'
    )
  end

  it 'routes GET /any/non-existent/path to Home#index' do
    expect({ get: '/any/non-existent/path' }).to route_to(
      controller: 'home',
      action: 'index',
      path: 'any/non-existent/path'
    )
  end
end
