# frozen_string_literal: true

module RatesHelper
  DENOMINATIONS = %w[
    BTC mBTC μBTC Satoshi USD EUR AUD BRL CAD CNY GBP IDR ILS JPY MXN NOK NZD PLN RON RUB SEK SGD ZAR
  ].freeze

  def denom_options_for_select
    # [["BTC", "0"], ["mBTC", "1"], ...
    DENOMINATIONS.each_with_index.map { |label, index| [label, index.to_s] }
  end

  def btc_human(amount, options = {})
    nobr = options.key?(:nobr) ? options[:nobr] : true
    denom = options.key?(:denom) ? options[:denom] : current_user&.denom || 0

    btc = to_denom(denom, amount)
    btc = "<nobr>#{btc}</nobr>" if nobr
    btc.html_safe
  end

  private

  def to_denom(denom, amount)
    amount ||= 0
    convert_method_name = "to_#{DENOMINATIONS[denom].gsub('μ', 'u').downcase}"
    send(convert_method_name, amount)
  end

  def to_btc(satoshies)
    format('%.8f Ƀ', (1.0 * satoshies.to_i / 1e8))
  end

  def to_mbtc(satoshies)
    format('%.5f mɃ', (1.0 * satoshies.to_i / 1e5))
  end

  def to_ubtc(satoshies)
    format('%.2f μɃ', (1.0 * satoshies.to_i / 1e2))
  end

  def to_satoshi(satoshies)
    format('%.0f Satoshi', satoshies)
  end

  def to_usd(satoshies)
    format('$%.2f', rate('USD', satoshies))
  end

  def to_aud(satoshies)
    format('$%.2f', rate('AUD', satoshies))
  end

  def to_eur(satoshies)
    format('%.2f€', rate('EUR', satoshies))
  end

  def to_brl(satoshies)
    format('R$%.2f', rate('BRL', satoshies))
  end

  def to_cad(satoshies)
    format('$%.2f', rate('CAD', satoshies))
  end

  def to_cny(satoshies)
    format('%.2f¥', rate('CNY', satoshies))
  end

  def to_gbp(satoshies)
    format('%.2f£', rate('GBP', satoshies))
  end

  def to_idr(satoshies)
    format('%.2f Rp', rate('IDR', satoshies))
  end

  def to_ils(satoshies)
    format('%.2f₪', rate('ILS', satoshies))
  end

  def to_jpy(satoshies)
    format('%.2f¥', rate('JPY', satoshies))
  end

  def to_mxn(satoshies)
    format('%.2f MXN', rate('MXN', satoshies))
  end

  def to_nok(satoshies)
    format('%.2f kr', rate('NOK', satoshies))
  end

  def to_nzd(satoshies)
    format('$%.2f', rate('NZD', satoshies))
  end

  def to_pln(satoshies)
    format('%.2f zł', rate('PLN', satoshies))
  end

  def to_ron(satoshies)
    format('%.2f lei', rate('RON', satoshies))
  end

  def to_rub(satoshies)
    format('%.2f₽', rate('RUB', satoshies))
  end

  def to_sek(satoshies)
    format('%.2f kr', rate('SEK', satoshies))
  end

  def to_sgd(satoshies)
    format('%.2f S$', rate('SGD', satoshies))
  end

  def to_zar(satoshies)
    format('%.2f R', rate('ZAR', satoshies))
  end

  def rate(currency, satoshies)
    satoshies * 0.00000001 * get_rate(currency)
  end

  def get_rate(currency)
    Rails.cache.fetch("####{currency}", expires_in: 1.hour) do
      uri = URI("https://api.coindesk.com/v1/bpi/currentprice/#{currency}.json")
      response = Net::HTTP.get_response(uri)
      hash = JSON.parse(response.body)
      hash['bpi'][currency]['rate_float'].to_f
    end
  end
end
