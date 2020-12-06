# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'routes for Users', type: :routing do
  it 'routes GET /users to User#index' do
    expect({ get: '/users' }).to route_to(
      controller: 'users',
      action: 'index'
    )
  end

  it 'routes GET /users/nick-name321 to User#show' do
    expect({ get: '/users/nick-name321' }).to route_to(
      controller: 'users',
      action: 'show',
      nickname: 'nick-name321'
    )
  end

  it 'routes GET /users/login to User#login' do
    expect({ get: '/users/login' }).to route_to(
      controller: 'users',
      action: 'login'
    )
  end

  it 'routes GET /users/1/tips to Tips#index' do
    expect({ get: '/users/1/tips' }).to route_to(
      controller: 'tips',
      action: 'index',
      user_id: '1'
    )
  end

  describe 'pretty url routing' do
    let(:user) { create(:user) }

    it 'regex rejects reserved user paths' do
      # accepted pertty url usernames
      should_accept = [' ', 'logi', 'ogin', 's4c2', '42x', 'nick name', 'kd']
      # reserved routes (rejected pertty url usernames)
      should_reject = ['', '1', '42']

      accepted = should_accept.select { |ea|  ea =~ /\D+/ }
      rejected = should_reject.select { |ea| (ea =~ /\D+/).nil? }
      (expect(accepted.size).to eq(should_accept.size)) &&
        (expect(rejected.size).to eq(should_reject.size))
    end

    it 'routes GET /users/:nickname to User#show' do
      expect({ get: "/users/#{user.nickname}" }).to route_to(
        controller: 'users',
        action: 'show',
        nickname: 'kd'
      )
    end

    it 'routes GET /users/:nickname/tips to Tips#index' do
      expect({ get: "/users/#{user.nickname}/tips" }).to route_to(
        controller: 'tips',
        action: 'index',
        nickname: 'kd'
      )
    end
  end
end
