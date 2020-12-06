# frozen_string_literal: true

module ApplicationHelper
  def render_flash_messages
    html = []
    flash.each do |type, message|
      alert_type = case type
                   when 'notice'          then :success
                   when 'alert', 'error'  then :danger
                   end
      html << tag.div(class: "alert alert-#{alert_type}") { message }
    end
    html.join("\n").html_safe
  end

  def commit_tag(sha1)
    tag.span(truncate(sha1, length: 10, omission: ''), class: 'commit-sha')
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
