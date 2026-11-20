# frozen_string_literal: true

require 'spec_helper'

describe RatesHelper, type: :helper do
  let(:rates_url) { 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=eur' }
  let(:eur) { RatesHelper::DENOMINATIONS.index('EUR') }

  before do
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
    allow(helper).to receive(:current_user).and_return(nil)
  end

  it 'shows bitcoin amounts without asking for a rate' do
    expect(helper.btc_human(150_000_000, nobr: false)).to eq('1.50000000 Ƀ')
  end

  it 'converts with the fetched rate' do
    stub_request(:get, rates_url).to_return(body: { bitcoin: { eur: 50_000 } }.to_json)
    expect(helper.btc_human(150_000_000, denom: eur, nobr: false)).to eq('75000.00€')
  end

  it 'asks for the rate once and reuses it' do
    request = stub_request(:get, rates_url).to_return(body: { bitcoin: { eur: 50_000 } }.to_json)
    2.times { helper.btc_human(100_000_000, denom: eur) }
    expect(request).to have_been_requested.once
  end

  it 'falls back to bitcoin when the rate service cannot be reached' do
    stub_request(:get, rates_url).to_raise(SocketError)
    expect(helper.btc_human(150_000_000, denom: eur, nobr: false)).to eq('1.50000000 Ƀ')
  end

  it 'falls back to bitcoin when the answer has no rate' do
    stub_request(:get, rates_url).to_return(status: 429, body: '{"status":{"error_code":429}}')
    expect(helper.btc_human(150_000_000, denom: eur, nobr: false)).to eq('1.50000000 Ƀ')
  end

  it 'does not ask again right after a failure' do
    request = stub_request(:get, rates_url).to_timeout
    2.times { helper.btc_human(100_000_000, denom: eur) }
    expect(request).to have_been_requested.once
  end
end
