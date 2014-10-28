module HomeHelper

  def list_friendly_text a_list
    # e.g. ['a']         => "a"
    #      ['a','b']     => "a or b"
    #      ['a','b','c'] => "a, b, or c"
    list = a_list.map { |ea| ea.to_s } ; last = list.pop
    (list.join ', ')               +
    ((list.size < 2)? "" : ",")    +
    ((list.empty?)  ? "" : " #{t('.contribute.or')} ") + last
  end

end
