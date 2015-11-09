module ApplicationHelper
  def btc_human amount, options = {}
    amount ||= 0
    nobr = options.has_key?(:nobr) ? options[:nobr] : true
    denom = options.has_key?(:denom) ? options[:denom] : (try(:current_user) ? current_user.denom : 0)
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

  def to_btc satoshies
    "%.8f Ƀ" % (1.0*satoshies.to_i/1e8)
  end

  def to_mbtc satoshies
    "%.5f mɃ" % (1.0*satoshies.to_i/1e5)
  end

  def to_ubtc satoshies
    "%.2f μɃ" % (1.0*satoshies.to_i/1e2)
  end

  def to_satoshi satoshies
    "%.0f Satoshi" % satoshies
  end

  def to_usd satoshies
    "$%.2f" % cource("USD", satoshies)
  end

  def to_aud satoshies
    "$%.2f" % cource("AUD", satoshies)
  end

  def to_eur satoshies
    "€%.2f" % cource("EUR", satoshies)
  end

  def to_brl satoshies
    "R$%.2f" % cource("BRL", satoshies)
  end

  def to_cad satoshies
    "$%.2f" % cource("CAD", satoshies)
  end

  def to_cny satoshies
    "¥%.2f" % cource("CNY", satoshies)
  end

  def to_gbp satoshies
    "£%.2f" % cource("GBP", satoshies)
  end

  def to_idr satoshies
    "Rp%.2f" % cource("IDR", satoshies)
  end

  def to_ils satoshies
    "₪%.2f" % cource("ILS", satoshies)
  end

  def to_jpy satoshies
    "¥%.2f" % cource("JPY", satoshies)
  end

  def to_mxn satoshies
    "$%.2f" % cource("MXN", satoshies)
  end

  def to_nok satoshies
    "kr%.2f" % cource("NOK", satoshies)
  end

  def to_nzd satoshies
    "$%.2f" % cource("NZD", satoshies)
  end

  def to_pln satoshies
    "zł%.2f" % cource("PLN", satoshies)
  end

  def to_ron satoshies
    "lei%.2f" % cource("RON", satoshies)
  end

  def to_rub satoshies
    "₽%.2f" % cource("RUB", satoshies)
  end

  def to_sek satoshies
    "kr%.2f" % cource("SEK", satoshies)
  end

  def to_sgd satoshies
    "$%.2f" % cource("SGD", satoshies)
  end

  def to_zar satoshies
    "R%.2f" % cource("ZAR", satoshies)
  end

  def cource(currency, satoshies)
    satoshies*0.00000001*get_cource(currency)
  end

  def get_cource(currency)
    Rails.cache.fetch("###" + currency, :expires_in => 24.hours) do
      uri = URI('https://api.bitcoinaverage.com/ticker/' + currency + '/')
      response = Net::HTTP.get_response(uri)
      hash = JSON.parse(response.body)
      hash["24h_avg"]
    end
  end 

  def render_flash_messages
    html = []
    flash.each do |_type, _message|
      alert_type = case _type
        when :notice         then :success
        when :alert, :error  then :danger
      end
      html << content_tag(:div, class: "alert alert-#{alert_type}"){ _message }
    end
    html.join("\n").html_safe
  end

  def commit_tag(sha1)
    content_tag(:span, truncate(sha1, length: 10, omission: ""), class: "commit-sha")
  end

  def list_friendly_text a_list , conjunction
    # e.g. ['a']         => "a"
    #      ['a','b']     => "a or b"
    #      ['a','b','c'] => "a, b, or c"
    list = a_list.map { |ea| ea.to_s } ; last = list.pop ;
    (list.join ', ')                                    +
    ((list.size < 2) ? "" : ",")                        +
    ((list.empty?)   ? "" : " #{conjunction} ") + last
  end
end
