require 'spec_helper'

describe Wallet, type: :model do
  let(:wallet) { create(:wallet) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:xpub) }
  end

  describe '#generate_address' do
    subject { wallet.generate_address }

    it 'should return a new address' do
      expect(subject).to eq '125q4q36PT2gGoeNWXm34RepMcgghLghiZ'
    end

    it 'should increment last_address_index' do
      expect { subject }.to change { wallet.reload.last_address_index }.by 1
    end
  end
end
