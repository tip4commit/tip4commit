module ApplicationHelper
  def btc_human amount, options = {}
    nobr = options.has_key?(:nobr) ? options[:nobr] : true
    btc = "%.8f Ƀ" % to_btc(amount)
    btc = "<nobr>#{btc}</nobr>" if nobr
    btc.html_safe
  end

  def to_btc satoshies
    (1.0*satoshies.to_i/1e8)
  end
end
