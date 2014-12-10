class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
    end    
  end

  def blockchain_info_callback
  # todo: check if remote IP address belongs to blockchain.info

    if (params[:secret]!=CONFIG["blockchain_info"]["callback_secret"])
      render :text => "Invalid secret #{params}!"
      return
    end

    test = params[:test]

    if (params[:value].to_i < 0) || Sendmany.find_by(txid: params[:transaction_hash])
      render :text => "*ok*";
      return
    end

    if project = Project.find_by(bitcoin_address: params[:input_address])
      deposit = project.deposits.find_by(txid: params[:transaction_hash])
    else
      deposit = nil
    end

    if deposit
      deposit.update_attribute(:confirmations, confirmations = params[:confirmations]) if !test
      if confirmations.to_i > 6
        render :text => "*ok*"
      else
        render :text => "Deposit #{deposit.id} updated!"
      end
      return
    end

    if params[:input_address] == CONFIG['deposit_address']
      # Deposit from the cold wallet
      render :text => "*ok*"
    elsif project
      if !test
        deposit = Deposit.create({
          project_id: project.id,
          txid: params[:transaction_hash],
          confirmations: params[:confirmations],
          amount: params[:value].to_i
        })
        project.update_cache
      end
      render :text => "Deposit #{deposit[:txid]} has been created!"
    else
      render :text => "Project with deposit address #{params[:input_address]} is not found!"
    end
  end

end
