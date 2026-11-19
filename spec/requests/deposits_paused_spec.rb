# frozen_string_literal: true

require 'spec_helper'

describe 'Project page deposit address', type: :request do
  let(:project) { create(:project, bitcoin_address: '1M4bS4gPyA6Kb8w7aXsgth9oUZWcRk73tQ') }

  it 'shows the address by default' do
    get "/github/#{project.full_name}"
    expect(response.body).to include(project.bitcoin_address)
  end

  context 'when deposits are paused' do
    before { stub_const('CONFIG', CONFIG.merge('deposits_paused' => true)) }

    it 'hides the address and says donations are paused' do
      get "/github/#{project.full_name}"
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include(project.bitcoin_address)
      expect(response.body).to include('New donations are paused')
    end
  end
end
