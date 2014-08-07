class DepositsController < ApplicationController
  before_action :load_project

  def index
    if params[:project_id]
      @deposits = @project.deposits.order(created_at: :desc).page(params[:page]).per(30)
    else
      @deposits = Deposit.includes(:project).order(created_at: :desc).page(params[:page]).per(30)
    end
  end

  private

  def load_project
    super(params[:project_id]) if params[:project_id].present?
  end
end
