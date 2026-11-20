# frozen_string_literal: true

# Price of one bitcoin in a fiat currency.
class BitcoinRate
  URL = 'https://api.coingecko.com/api/v3/simple/price'

  class Unavailable < StandardError; end

  # The rate is cached for an hour; a failed lookup is remembered for five
  # minutes so a page does not wait for the rate service again and again.
  def self.fetch(currency)
    key = "btc_rate/#{currency}"
    rate = Rails.cache.read(key)
    if rate.nil?
      rate = request(currency) || 0.0
      Rails.cache.write(key, rate, expires_in: rate.positive? ? 1.hour : 5.minutes)
    end
    raise Unavailable unless rate.positive?

    rate
  end

  def self.request(currency)
    code = currency.downcase
    uri = URI("#{URL}?ids=bitcoin&vs_currencies=#{code}")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 3, read_timeout: 3) do |http|
      http.get(uri.request_uri)
    end
    Float(JSON.parse(response.body).dig('bitcoin', code))
  rescue StandardError => e
    Rails.logger.warn("Bitcoin rate for #{currency} unavailable: #{e.class}: #{e.message}")
    nil
  end
  private_class_method :request
end
