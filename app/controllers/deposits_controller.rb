class DepositsController < ApplicationController
  before_action { load_project params }

  def index
    if @project.present?
      @deposits = @project.deposits
    else
      @deposits = Deposit.includes(:project)
    end
    @deposits = @deposits.order(created_at: :desc).
                          page(params[:page]).
                          per(params[:per_page] || 30)
    respond_to do |format|
      format.html
      format.csv { render csv: @deposits, except: [:updated_at, :confirmations, :fee_size], add_methods: [:project_name, :fee, :confirmed?] }
    end
  end
end
