# frozen_string_literal: true

require 'spec_helper'

describe Collaborator, type: :model do
  describe 'Associations' do
    it { should belong_to :project }
  end
end
