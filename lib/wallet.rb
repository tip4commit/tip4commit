class Wallet

  # @return Hash  - {"address"=>"1VhXRDrsBnmqgLzkAizb2RTDWNLqQDaiz", "index"=>0, "callback"=>"https://b27d33dc.ngrok.io/blockchain_info_callback_v2"} 
  class << self
    def generate_address_and_register_callback
      callback_url = 'https://'+CONFIG['app_host']+'/blockchain_info_callback_v2/'+CONFIG['blockchain_info']['callback_secret2']
      params = {
        xpub: CONFIG['wallet']['xpub'],
        callback: callback_url,
        key: CONFIG['blockchain_info']['api_key']
      }
      response = RestClient.get "https://api.blockchain.info/v2/receive", params: params
      return JSON.parse(response)
    rescue RestClient::BadRequest => e
      return e
    end
  end

  # Callback response example
  # 
  # GET /blockchain_info_callback_v2?address=1VhXRDrsBnmqgLzkAizb2RTDWNLqQDaiz&transaction_hash=6b3653774e7d71b8b802dc39cc885027eae8e4f1488fcdc39c72bcdcd2abbc67&value=100000&confirmations=0
  # User-Agent: Blockchain.info Receive Payments Callback Client


end
