module ApplicationHelper
  def btc_human amount, options = {}
    nobr = options.has_key?(:nobr) ? options[:nobr] : true
    currency = options[:currency] || false
    btc = "%.8f Ƀ" % to_btc(amount)
    btc = "<span class='convert-from-btc' data-to='#{currency.upcase}'>#{btc}</span>" if currency
    btc = "<nobr>#{btc}</nobr>" if nobr
    btc.html_safe
  end

  def to_btc satoshies
    (1.0*satoshies.to_i/1e8)
  end
end
