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
    "%.2f $" % cource("USD", satoshies)
  end

  def to_eur satoshies
    "%.2f €" % cource("EUR", satoshies)
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
