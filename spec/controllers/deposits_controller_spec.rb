# frozen_string_literal: true

require 'spec_helper'

describe DepositsController, type: :controller do
  describe "GET 'index'" do
    it 'returns http success' do
      get 'index'
      expect(response).to be_successful
    end
  end

  describe 'routing' do
    it 'routes GET / to Deposits#index' do
      expect({ get: '/deposits' }).to route_to(
        controller: 'deposits',
        action: 'index'
      )
    end
  end
end
