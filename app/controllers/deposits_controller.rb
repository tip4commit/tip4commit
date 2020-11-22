# frozen_string_literal: true

class DepositsController < ApplicationController
  before_action { load_project params }

  def index
    @deposits = if @project.present?
                  @project.deposits
                else
                  Deposit.includes(:project)
                end
    @deposits = @deposits.order(created_at: :desc)
                         .page(params[:page])
                         .per(params[:per_page] || 30)
    respond_to do |format|
      format.html
      format.csv { render csv: @deposits, except: %i[updated_at confirmations fee_size], add_methods: %i[project_name fee confirmed?] }
    end
  end
end
