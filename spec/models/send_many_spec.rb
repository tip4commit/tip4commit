# frozen_string_literal: true

require 'spec_helper'

describe Sendmany, type: :model do
  describe 'Associations' do
    it { should have_many :tips }
  end
end
