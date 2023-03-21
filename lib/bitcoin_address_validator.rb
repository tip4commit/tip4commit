# frozen_string_literal: true

require 'digest'

class BitcoinAddressValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank? || valid_bitcoin_address?(value)

    record.errors.add(field, :invalid, message: 'Bitcoin address is invalid')
  end

  private

  BECH32_HRP = {
    mainnet: 'bc',
    testnet: 'tb'
  }.freeze

  def valid_bitcoin_address?(addr)
    valid_segwit_address?(addr) || valid_legacy_address?(addr)
  end

  def valid_segwit_address?(addr)
    segwit_addr = parse_segwit_address(addr)
    return true if segwit_addr && segwit_addr.hrp == BECH32_HRP[CONFIG['network'].to_sym]

    false
  end

  def parse_segwit_address(addr)
    Bech32::SegwitAddr.new(addr)
  rescue RuntimeError => e
    return nil if e.message == 'Invalid address.'

    raise
  end

  B58_CHARS = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  B58_BASE = B58_CHARS.length

  EXPECTED_VERSIONS = {
    mainnet: [0, 5],
    testnet: [111, 196]
  }.freeze

  def valid_legacy_address?(address)
    if (address =~ /^[a-zA-Z1-9]{33,35}$/) && (version = version(address))
      if (expected_versions = EXPECTED_VERSIONS[CONFIG['network'].to_sym]).present?
        expected_versions.include?(version.ord)
      else
        true
      end
    else
      false
    end
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
    result = ''

    value.reverse.each_char do |c|
      long_value += B58_CHARS.index(c) * (B58_BASE**index)
      index += 1
    end

    while long_value >= 256
      div, mod = long_value.divmod 256
      result = mod.chr + result
      long_value = div
    end

    result = long_value.chr + result

    result = (0.chr * (length - result.length)) + result if result.length < length

    result
  end
end
