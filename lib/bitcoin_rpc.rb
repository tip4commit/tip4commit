# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class BitcoinRPC
  def initialize(service_url, batch_mode = false)
    @service_url = service_url
    @uri = URI.parse(service_url)
    set_batch_mode(batch_mode)
  end

  def set_batch_mode(m)
    @batch_mode = m
  end

  def method_missing(name, *args)
    if (@batch_mode)
      { 'method' => name, 'params' => args, 'id' => 'jsonrpc', 'jsonrpc' => '2.0' }
    else
      post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
      resp = JSON.parse(http_post_request(post_body))
      raise JSONRPCError, resp['error'] if resp['error']

      resp['result']
    end
  end

  def commit(reqs)
    post_body = reqs.to_json
    resp = JSON.parse(http_post_request(post_body))
    raise JSONRPCError, resp if resp.length != reqs.length

    resp
  end

  def http_post_request(post_body)
    RestClient.post(@service_url, post_body, content_type: :json, accept: :json).body
  end

  class JSONRPCError < RuntimeError; end
end
