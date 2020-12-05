# frozen_string_literal: true

require 'spec_helper'

describe Collaborator, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :project }
  end
end
