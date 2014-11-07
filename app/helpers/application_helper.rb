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
