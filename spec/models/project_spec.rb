require 'spec_helper'

describe Project do
  let(:project) { create(:project) }
  let(:project_of_bitbucket) { create(:project, :bitbucket) }

  describe 'Associations' do
    it { should have_many(:deposits) }
    it { should have_many(:tips) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:github_id) }
    it { should validate_presence_of(:host) }
    it { should validate_uniqueness_of(:full_name) }
    it { should validate_uniqueness_of(:github_id) }
    it { should ensure_inclusion_of(:host).in_array([ "github", "bitbucket" ]) }
  end

  describe '#repository_client' do
    context 'when host is github' do
      it 'returns Github instance' do
        expect(project.repository_client).to be_a Github
      end
    end

    context 'when host is bitbucket' do
      it 'returns Bitbucket instance' do
        expect(project_of_bitbucket.repository_client).to be_a Bitbucket
      end
    end

    context 'when host is blank' do
      before { project.host = '' }

      it 'returns NilClass instance' do
        expect(project.repository_client).to be_a NilClass
      end
    end
  end
end
