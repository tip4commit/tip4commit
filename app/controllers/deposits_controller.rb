# frozen_string_literal: true

class DepositsController < ApplicationController
  before_action { load_project }

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

  private

  def load_project
    return unless pretty_project_path? || params[:project_id].present?

    if pretty_project_path?
      @project = Project.find_by_service_and_repo(params[:service], params[:repo])
    elsif params[:project_id].present?
      @project = Project.where(id: params[:project_id]).first
      redirect_to project_deposits_pretty_path(@project.host, @project.full_name) if @project
    end

    project_not_found unless @project
  end
end
