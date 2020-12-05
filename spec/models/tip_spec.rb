# frozen_string_literal: true

require 'spec_helper'

describe Tip, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :sendmany }
    it { is_expected.to belong_to :project }
  end
end
