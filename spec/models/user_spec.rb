# frozen_string_literal: true

require 'spec_helper'

describe User, type: :model do
  let(:user) { create(:user) }

  describe 'Associations' do
    it { is_expected.to have_many :tips }
  end

  describe 'full_name' do
    context 'when name is present' do
      it 'returns name' do
        expect(user.display_name).to eq(user.name)
      end
    end

    context 'when name is absent and nickname is present' do
      it 'returns nickname' do
        user.name = nil
        expect(user.display_name).to eq(user.nickname)
      end
    end

    context 'when name and nickname is absent and email is absent' do
      it 'returns email' do
        user.name = user.nickname = nil
        expect(user.display_name).to eq(user.email)
      end
    end
  end

  describe 'bitcoin_address' do
    context 'when address is blank' do
      it 'is valid' do
        user.bitcoin_address = ''
        expect(user).to be_valid
      end
    end

    context 'when address is valid p2pkh address' do
      it 'is valid' do
        user.bitcoin_address = '1M4bS4gPyA6Kb8w7aXsgth9oUZWcRk73tQ'
        expect(user).to be_valid
      end
    end

    context 'when address is valid p2sh address' do
      it 'is valid' do
        user.bitcoin_address = '3EktnHQD7RiAE6uzMj2ZifT9YgRrkSgzQX'
        expect(user).to be_valid
      end
    end

    context 'when address is valid bech32 P2WPKH address' do
      it 'is valid' do
        user.bitcoin_address = 'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4'
        expect(user).to be_valid
      end
    end

    context 'when address is valid bech32 P2WSH address' do
      it 'is valid' do
        user.bitcoin_address = 'bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3'
        expect(user).to be_valid
      end
    end

    context 'when address is not valid p2pkh' do
      it 'is not valid' do
        user.bitcoin_address = '1M4bS4gPyA6Kb8w7aXsgth9oUZXXXXXXXX'
        expect(user).not_to be_valid
      end
    end

    context 'when address is testnet bech32' do
      it 'is not valid' do
        user.bitcoin_address = 'tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx'
        expect(user).not_to be_valid
      end
    end

    context 'when address is not valid bech32' do
      it 'is not valid' do
        user.bitcoin_address = 'tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx'
        expect(user).not_to be_valid
      end
    end
  end

  describe 'payout hold' do
    let(:user) { create(:user, bitcoin_address: '1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2') }

    before do
      project = create(:project)
      create(:deposit, project:, confirmations: Deposit::CONFIRMATIONS_NEEDED, amount: CONFIG['min_payout'] * 10)
      create(:tip, user:, project:, amount: CONFIG['min_payout'])
    end

    it 'is ready for withdrawal when not held' do
      expect(user).to be_ready_for_withdrawal
    end

    it 'is not ready while held and records the reason' do
      user.hold_payouts!('address changed')
      expect(user.reload).to be_payout_hold
      expect(user).not_to be_ready_for_withdrawal
      expect(user.payout_hold_reason).to eq 'address changed'
    end

    it 'is ready again after release and clears the reason' do
      user.hold_payouts!('address changed')
      user.release_payouts!
      expect(user.reload).not_to be_payout_hold
      expect(user).to be_ready_for_withdrawal
      expect(user.payout_hold_reason).to be_nil
    end

    it 'requires a reason to hold' do
      expect { user.hold_payouts!('  ') }.to raise_error(ArgumentError)
      expect { user.hold_payouts!(nil) }.to raise_error(ArgumentError)
      expect(user.reload).not_to be_payout_hold
    end

    it 'stays not ready when held without an address' do
      user.update!(bitcoin_address: '')
      user.hold_payouts!('x')
      expect(user).not_to be_ready_for_withdrawal
    end
  end
end
