# frozen_string_literal: true

require 'spec_helper'

describe Tip, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
    it { should belong_to :sendmany }
    it { should belong_to :project }
  end
end
