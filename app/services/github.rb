class Github
  def initialize
    options = { client_id: CONFIG['github']['key'], client_secret: CONFIG['github']['secret'] }
    if CONFIG['github']['auto_paginate']
      options.merge! :auto_paginate  => true
    else
      options.merge! :per_page => 100
    end
    @client = Octokit::Client.new(options)
  end

  attr_reader :client

  def commits project
    if project.branch.blank?
      commits = client.commits project.full_name
    else
      commits = client.commits project.full_name, sha: project.branch
    end

    last_response = client.last_response
    pages = (CONFIG['github']['project_pages'][project.full_name] || CONFIG['github']['pages'] || 1).to_i
    (pages - 1).times do
      if last_response.rels[:next]
        last_response = last_response.rels[:next].get
        commits += last_response.data
      end
    end

    commits
  end

  def repository_info project
    if project.is_a?(String)
      client.repo project
    elsif project.is_a?(Project)
      if project.github_id.present?
        client.get "/repositories/#{project.github_id}"
      else
        client.repo project.full_name
      end
    else
      raise 'Unknown parameter class'
    end
  end

  def find_or_create_project project_name
    if project = find_project(project_name)
      project
    elsif project_name =~ /\w+\/\w+/
      begin
        repo = repository_info project_name
        project = Project.find_or_create_by host: "github", full_name: repo.full_name
        project.update_repository_info repo
        project
      rescue Octokit::NotFound
        nil
      end
    else
      nil
    end
  end

  def find_project project_name
    return Project.find_by(host: "github", full_name: project_name)
  end

  def collaborators_info project
    (client.get("/repos/#{project.full_name}/collaborators") rescue []) +
    (client.get("/orgs/#{project.full_name.split('/').first}/members") rescue [])
  end

  def branches project
    branches = client.get("/repos/#{project.full_name}/branches")
    last_response = client.last_response
    while last_response && last_response.rels[:next]
      last_response = last_response.rels[:next].get
      branches += last_response.data
    end
    branches.map(&:name)
  end

  def repository_url project
    "https://github.com/#{project.full_name}"
  end

  def source_repository_url project
    "https://github.com/#{project.source_full_name}"
  end

  def commit_url project, commit
    "https://github.com/#{project.full_name}/commit/#{commit}"
  end
end
