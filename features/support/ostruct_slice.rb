# frozen_string_literal: true

require 'ostruct'

class OpenStruct
  def slice(...)
    marshal_dump.slice(...)
  end
end
