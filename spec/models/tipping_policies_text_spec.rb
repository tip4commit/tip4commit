# frozen_string_literal: true

require 'spec_helper'

describe TippingPoliciesText, type: :model do
  describe 'Associations' do
    it { should belong_to :project }
    it { should belong_to :user }
  end
end
