# frozen_string_literal: true

require 'spec_helper'

describe Wallet, type: :model do
  let(:wallet) { create(:wallet) }

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:xpub) }
  end

  describe '#generate_address' do
    subject { wallet.generate_address }

    it 'returns a new address' do
      expect(subject).to eq '125q4q36PT2gGoeNWXm34RepMcgghLghiZ'
    end

    it 'increments last_address_index' do
      expect { subject }.to change { wallet.reload.last_address_index }.by 1
    end
  end
end
