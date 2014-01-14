require 'digest'

class BitcoinAddressValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    unless value.blank? || valid_bitcoin_address?(value)
      record.errors[field] << "Bitcoin address is invalid"
    end
  end

  private

  B58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  B58Base = B58Chars.length

  def valid_bitcoin_address?(address)
    (address =~ /^[a-zA-Z1-9]{33,35}$/) and version(address)
  end

  def version(address)
    decoded = b58_decode(address, 25)
    
    version = decoded[0, 1]
    checksum = decoded[-4, decoded.length]
    vh160 = decoded[0, decoded.length - 4]

    hashed = (Digest::SHA2.new << (Digest::SHA2.new << vh160).digest).digest

    hashed[0, 4] == checksum ? version[0] : nil
  end

  def b58_decode(value, length)
    long_value = 0
    index = 0
    result = ""

    value.reverse.each_char do |c|
      long_value += B58Chars.index(c) * (B58Base ** index)
      index += 1
    end

    while long_value >= 256 do
      div, mod = long_value.divmod 256
      result = mod.chr + result
      long_value = div
    end

    result = long_value.chr + result

    if result.length < length
      result = 0.chr * (length - result.length) + result
    end

    result
  end
end