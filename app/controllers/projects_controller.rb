require 'net/http'

class ProjectsController < ApplicationController

  before_filter :load_project, only: :show

  def index
    @projects = Project.order(available_amount_cache: :desc, watchers_count: :desc, full_name: :asc).page(params[:page]).per(30)
  end
  
  def by_watchers
    @projects = Project.order(watchers_count: :desc, available_amount_cache: :desc, full_name: :asc).page(params[:page]).per(30)
    render "index"
  end

  def show
    if @project.bitcoin_address.nil?
      uri = URI("https://blockchain.info/merchant/#{CONFIG["blockchain_info"]["guid"]}/new_address")
      params = { password: CONFIG["blockchain_info"]["password"], label:"#{@project.full_name}@tip4commit" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess) && (bitcoin_address = JSON.parse(res.body)["address"])
        @project.update_attribute :bitcoin_address, bitcoin_address
      end      
    end
    @project.includes(:tips)
    @recent_tips = @project.tips.includes(:user).order(created_at: :desc).first(5)
  end

  def create
    project_name = params[:full_name].
      gsub(/https?\:\/\/github.com\//, '').
      gsub(/\#.+$/, '').
      gsub(' ', '')
    client = Octokit::Client.new \
      :client_id     => CONFIG['github']['key'],
      :client_secret => CONFIG['github']['secret']
    begin
      repo = client.repo project_name
      @project = Project.find_or_create_by host: "github", full_name: repo.full_name
      @project.update_repository_info repo
      redirect_to @project
    rescue Octokit::NotFound
      redirect_to projects_path, alert: "Project not found"
    end
  end

  private

  def load_project
    super(params[:id])
  end
end
