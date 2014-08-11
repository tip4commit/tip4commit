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
    commits = client.commits project.full_name

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
    if project.github_id.present?
      client.get "/repositories/#{project.github_id}"
    else
      client.repo project.full_name
    end
  end

  def collaborators_info project
    client.get("/repos/#{project.full_name}/collaborators") +
    (client.get("/orgs/#{project.full_name.split('/').first}/members") rescue [])
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
