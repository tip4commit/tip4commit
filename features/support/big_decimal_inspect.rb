# frozen_string_literal: true

class BigDecimal
  def inspect
    "<BigDecimal:#{to_s('F')}>"
  end
end
