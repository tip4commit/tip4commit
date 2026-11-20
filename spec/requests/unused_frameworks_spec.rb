# frozen_string_literal: true

require 'spec_helper'

describe 'Unused Rails frameworks', type: :request do
  it 'does not define Active Storage, Action Mailbox or Action Cable' do
    expect(defined?(ActiveStorage)).to be_nil
    expect(defined?(ActionMailbox)).to be_nil
    expect(defined?(ActionCable)).to be_nil
  end

  it 'has no routes under /rails' do
    paths = Rails.application.routes.routes.map { |route| route.path.spec.to_s }
    expect(paths.grep(%r{\A/rails/})).to be_empty
  end
end
