# frozen_string_literal: true

require 'spec_helper'

describe Github do
  let(:project) { build(:project, full_name: 'example/repo', branch: nil) }

  it 'raises Octokit::NotFound when GitHub answers 404' do
    stub_request(:get, %r{\Ahttps://api\.github\.com/repos/example/repo\z})
      .to_return(status: 404, body: '{"message":"Not Found"}', headers: { 'Content-Type' => 'application/json' })

    expect { described_class.new.repository_info('example/repo') }.to raise_error(Octokit::NotFound)
  end

  it 'raises Octokit::InternalServerError when GitHub answers 500' do
    stub_request(:get, %r{\Ahttps://api\.github\.com/repos/example/repo/commits})
      .to_return(status: 500, body: '{"message":"Server Error"}', headers: { 'Content-Type' => 'application/json' })

    expect { described_class.new.commits(project) }.to raise_error(Octokit::InternalServerError)
  end
end
