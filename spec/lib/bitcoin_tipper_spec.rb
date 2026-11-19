# frozen_string_literal: true

require 'spec_helper'

describe BitcoinTipper do
  describe '.calculate_outputs' do
    let(:sendmany) { Sendmany.create }
    let(:normal_user) { create(:user, login_token: 'normal', bitcoin_address: '1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2') }
    let(:held_user) { create(:user, login_token: 'held', bitcoin_address: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa') }
    let(:normal_tip) { normal_user.tips.first }
    let(:held_tip) { held_user.tips.first }

    before do
      project = create(:project)
      create(:deposit, project:, confirmations: Deposit::CONFIRMATIONS_NEEDED, amount: CONFIG['min_payout'] * 10)
      create(:tip, user: normal_user, project:, amount: CONFIG['min_payout'])
      create(:tip, user: held_user, project:, amount: CONFIG['min_payout'])
      held_user.hold_payouts!('under review')
    end

    it 'excludes held users from the outputs' do
      outputs = described_class.calculate_outputs(sendmany)
      expect(outputs).to eq(normal_user.bitcoin_address => CONFIG['min_payout'])
    end

    it 'leaves the held user\'s tips unassigned to the sendmany' do
      described_class.calculate_outputs(sendmany)
      expect(held_tip.reload.sendmany_id).to be_nil
      expect(normal_tip.reload.sendmany_id).to eq sendmany.id
    end
  end
end
