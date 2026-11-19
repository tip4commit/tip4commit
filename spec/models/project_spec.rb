# frozen_string_literal: true

require 'spec_helper'

describe Project, type: :model do
  let(:project) { create(:project) }
  let(:project_of_bitbucket) { create(:project, :bitbucket) }

  describe 'Associations' do
    it { is_expected.to have_many(:deposits) }
    it { is_expected.to have_many(:tips) }
    it { is_expected.to belong_to(:wallet) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_uniqueness_of(:full_name) }
    it { is_expected.to validate_uniqueness_of(:github_id) }
    it { is_expected.to validate_inclusion_of(:host).in_array %w[github bitbucket] }
  end

  describe 'bitcoin_address' do
    let(:wallet) { create(:wallet) }

    before do
      create(:wallet, xpub: 'xpub1key')
      wallet
    end

    it 'generates a bitcoin address' do
      expect(project.bitcoin_address).not_to be_blank
    end

    it 'connects project to the last wallet' do
      expect(project.wallet).to eq wallet
    end

    it "increments wallet's last_address_index" do
      expect { project }.to change { wallet.reload.last_address_index }.by 1
    end
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

  describe 'finding a project by URL' do
    let(:github) { instance_double(Github) }
    let(:url) { 'https://github.com/example/my repo#readme' }

    before { allow(Github).to receive(:new).and_return(github) }

    it 'looks up the repository name taken from the URL' do
      allow(github).to receive(:find_project).with('example/myrepo').and_return(:found)

      expect(described_class.find_by_url(url)).to eq(:found)
    end

    it 'finds or creates the project for the repository name taken from the URL' do
      allow(github).to receive(:find_or_create_project).with('example/myrepo').and_return(:created)

      expect(described_class.find_or_create_by_url(url)).to eq(:created)
    end
  end

  describe 'unexpected errors from the repository host' do
    let(:logged) { a_string_including("Project ##{project.id}", 'RuntimeError', 'boom') }

    before { allow(Airbrake).to receive(:notify) }

    it 'logs the error class, message and project id from #new_commits' do
      allow(project).to receive(:raw_commits).and_raise(RuntimeError, 'boom')
      allow(project).to receive(:sleep)
      expect(Rails.logger).to receive(:error).with(logged)

      expect(project.new_commits).to eq []
    end

    it 'logs the error class, message and project id from #update_info' do
      allow(project).to receive(:repository_info).and_raise(RuntimeError, 'boom')
      expect(Rails.logger).to receive(:error).with(logged)

      project.update_info
    end
  end
end
