require 'spec_helper'

describe Blacklist do
  it 'handles blacklisted URLs' do
    urls = [
      "https://github.com/author/notips",
      "https://bitbucket.org/author/notips",
      "https://github.com/notips/*",
      "https://bitbucket.org/notips/*",
    ]

    list = Blacklist.new(urls)

    # Blacklisted projects.
    expect(list.include?("https://github.com/author/notips")).to eq(true)
    expect(list.include?("http://github.com/author/notips?tips=true")).to eq(true)
    expect(list.include?("https://bitbucket.org/author/notips")).to eq(true)
    expect(list.include?("github.com/author/notips")).to eq(true)
    expect(list.include?("author/notips")).to eq(true)

    # Non-blacklisted projects.
    expect(list.include?("https://github.com/author/tipme")).to eq(false)
    expect(list.include?("https://bitbucket.org/author/tipme")).to eq(false)

    # Blacklisted authors.
    expect(list.include?("https://github.com/notips/tipme")).to eq(true)
    expect(list.include?("https://bitbucket.org/notips/tipme")).to eq(true)
  end
end
