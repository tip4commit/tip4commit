# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'routes for Tips', type: :routing do
  it 'routes GET / to Tips#index' do
    expect({ get: '/tips' }).to route_to(
      controller: 'tips',
      action: 'index'
    )
  end
end
