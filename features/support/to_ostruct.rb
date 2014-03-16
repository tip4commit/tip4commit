require 'ostruct'

class Hash
  def to_ostruct
    o = OpenStruct.new(self)
    each do |k,v|
      o.send(:"#{k}=", v.to_ostruct) if v.respond_to? :to_ostruct
    end
    o
  end
end

class Array
  def to_ostruct
    map do |item|
      if item.respond_to? :to_ostruct
        item.to_ostruct
      else
        item
      end
    end
  end
end
