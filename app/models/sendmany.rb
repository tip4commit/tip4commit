class Sendmany < ActiveRecord::Base
  has_many :tips, dependent: :destroy

	def send_transaction
    return if txid || is_error

  	update_attribute :is_error, true # it's a lock to prevent duplicates
		uri = URI("https://blockchain.info/merchant/#{CONFIG["blockchain_info"]["guid"]}/sendmany")
		params = { password: CONFIG["blockchain_info"]["password"], recipients: data }
	    uri.query = URI.encode_www_form(params)
        res = Net::HTTP.get_response(uri)
        if res.is_a?(Net::HTTPSuccess) && (json = JSON.parse(res.body))
        	Rails.logger.info res.body
        	update_attribute :result, json
        	if !(txid = json["tx_hash"]).blank?
	        	update_attribute :is_error, false
	        	update_attribute :txid, json["tx_hash"]
	        end
	    else
	    	Rails.logger.error "Failed to get correct response from blockchain.info"
      end
	end
end
