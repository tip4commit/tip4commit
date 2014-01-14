class WithdrawalsController < ApplicationController
  def index
    @sendmanies = Sendmany.order(created_at: :desc).page(params[:page]).per(30)
  end
end