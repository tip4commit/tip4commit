# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'routes for Withdrawals', type: :routing do
  it 'routes GET / to Withdrawals#index' do
    expect({ get: '/withdrawals' }).to route_to(
      controller: 'withdrawals',
      action: 'index'
    )
  end
end
