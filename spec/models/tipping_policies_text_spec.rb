# frozen_string_literal: true

require 'spec_helper'

describe TippingPoliciesText, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :project }
    it { is_expected.to belong_to :user }
  end
end
