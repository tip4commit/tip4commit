# frozen_string_literal: true

require 'spec_helper'

describe 'Assets', type: :feature do
  let(:locales) { Rails.application.config.available_locales }

  it 'has a flag image for each locale' do
    locales.each do |locale|
      path = Rails.root.join("app/assets/images/flags/#{locale}.png")
      expect(File.exist?(path)).to be_truthy, "#{locale} flag is missing"
    end
  end
end
