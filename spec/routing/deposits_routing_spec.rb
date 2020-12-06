# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'routes for Deposits', type: :routing do
  it 'routes GET / to Deposits#index' do
    expect({ get: '/deposits' }).to route_to(
      controller: 'deposits',
      action: 'index'
    )
  end
end
