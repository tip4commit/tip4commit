require 'spec_helper'

describe Deposit do
  let(:deposit) { create(:deposit) }

  describe 'Associations' do
    it { should belong_to :project }
  end

  describe '#fee' do
    it 'returns amount * fee' do
      with_custom_fee do
        expect(deposit.fee).to eq (deposit.amount * 0.01).to_i
      end
    end
  end

  describe '#available_amount' do
    it 'returns max of [(amount - fee), 0]' do
      with_custom_fee do
        deposit.amount = 100
        expect(deposit.available_amount).to eq 99
        deposit.amount = 0
        expect(deposit.available_amount).to eq 0
      end
    end
  end

  private

  def with_custom_fee
    old_fee = CONFIG["our_fee"]
    CONFIG["our_fee"] = 0.01
    yield
  ensure
    CONFIG["our_fee"] = old_fee
  end

end