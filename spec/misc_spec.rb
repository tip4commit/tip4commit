require 'spec_helper'

describe 'Misc tets' do
  let(:locales) { Rails.application.config.available_locales }

  it 'has a flag image for each locale' do
    locales.each do |locale|
      path = File.join(Rails.root, 'app', 'assets', 'images', 'flags', "#{locale}.png")
      expect(File.exists?(path)).to be_truthy, "#{locale} flag is missing"
    end
  end
end
