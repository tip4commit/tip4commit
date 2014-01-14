require 'net/http'

class ProjectsController < ApplicationController
  def index
    @projects = Project.order(available_amount_cache: :desc, watchers_count: :desc, full_name: :asc).page(params[:page]).per(30)
  end

  def show
    @project = Project.find params[:id]
    if @project && @project.bitcoin_address.nil?
      uri = URI("https://blockchain.info/merchant/#{CONFIG["blockchain_info"]["guid"]}/new_address")
      params = { password: CONFIG["blockchain_info"]["password"], label:"#{@project.full_name}@tip4commit" }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess) && (bitcoin_address = JSON.parse(res.body)["address"])
        @project.update_attribute :bitcoin_address, bitcoin_address
      end      
    end
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
      @project = Project.find_or_create_by full_name: repo.full_name
      @project.update_github_info repo
      redirect_to @project
    rescue Octokit::NotFound
      redirect_to projects_path, alert: "Project not found"
    end
  end
end
