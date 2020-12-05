# frozen_string_literal: true

require 'spec_helper'

describe Sendmany, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many :tips }
  end
end
