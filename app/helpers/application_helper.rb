module ApplicationHelper
  def btc_human(amount, options = {})
    amount ||= 0
    nobr = options.key?(:nobr) ? options[:nobr] : true
    denom = options.key?(:denom) ? options[:denom] : (try(:current_user) ? current_user.denom : 0)
    if denom === 0
      btc = to_btc(amount)
    elsif denom === 1
      btc = to_mbtc(amount)
    elsif denom === 2
      btc = to_ubtc(amount)
    elsif denom === 3
      btc = to_satoshi(amount)
    elsif denom === 4
      btc = to_usd(amount)
    elsif denom === 5
      btc = to_eur(amount)
    elsif denom === 6
      btc = to_aud(amount)
    elsif denom === 7
      btc = to_brl(amount)
    elsif denom === 8
      btc = to_cad(amount)
    elsif denom === 9
      btc = to_cny(amount)
    elsif denom === 10
      btc = to_gbp(amount)
    elsif denom === 11
      btc = to_idr(amount)
    elsif denom === 12
      btc = to_ils(amount)
    elsif denom === 13
      btc = to_jpy(amount)
    elsif denom === 14
      btc = to_mxn(amount)
    elsif denom === 15
      btc = to_nok(amount)
    elsif denom === 16
      btc = to_nzd(amount)
    elsif denom === 17
      btc = to_pln(amount)
    elsif denom === 18
      btc = to_ron(amount)
    elsif denom === 19
      btc = to_rub(amount)
    elsif denom === 20
      btc = to_sek(amount)
    elsif denom === 21
      btc = to_sgd(amount)
    elsif denom === 22
      btc = to_zar(amount)
    end
    btc = "<nobr>#{btc}</nobr>" if nobr
    btc.html_safe
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
    Rails.cache.fetch('###' + currency, expires_in: 24.hours) do
      uri = URI('https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC' + currency)
      response = Net::HTTP.get_response(uri)
      hash = JSON.parse(response.body)
      hash['averages']['day'].to_f
    end
  end

  def render_flash_messages
    html = []
    flash.each do |type, message|
      alert_type = case type
                   when 'notice'          then :success
                   when 'alert', 'error'  then :danger
                   end
      html << content_tag(:div, class: "alert alert-#{alert_type}") { message }
    end
    html.join("\n").html_safe
  end

  def commit_tag(sha1)
    content_tag(:span, truncate(sha1, length: 10, omission: ''), class: 'commit-sha')
  end

  def list_friendly_text(a_list, conjunction)
    # e.g. ['a']         => "a"
    #      ['a','b']     => "a or b"
    #      ['a','b','c'] => "a, b, or c"
    list = a_list.map(&:to_s)
    last = list.pop
    (list.join ', ')                                    +
      (list.size < 2 ? '' : ',')                        +
      (list.empty?   ? '' : " #{conjunction} ") + last
  end

  def block_explorer_tx_url(txid)
    "https://tradeblock.com/bitcoin/tx/#{txid}"
  end
end
