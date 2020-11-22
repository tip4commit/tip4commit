# frozen_string_literal: true

require 'set'

class Blacklist
  def initialize(urls)
    urls = urls.map { |u| normalize_url(u) }

    @urls = Set.new(urls)
  end

  def include?(url)
    url = normalize_url(url)

    return true if @urls.include?(url)

    # Check for the author path.
    # https://github.com/author/*
    url[url.rindex('/')..-1] = '/*'

    @urls.include?(url)
  end

  private

  def normalize_url(url)
    url = url.dup

    unless url.start_with?('http://', 'https://', '//')
      unless url.start_with?('github.com', 'bitbucket.org')
        # Assume it is a shortened "author/project" path and
        # default to Github.
        url.prepend('github.com/')
      end
      url.prepend('https://')
    end

    uri = URI.parse(url)

    # Ignore irrelevant differences such as HTTP/HTTPS.
    [uri.host, uri.path].join
  end
end
