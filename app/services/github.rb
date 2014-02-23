class Github
  def initialize
    @client = Octokit::Client.new(
      :client_id     => CONFIG['github']['key'],
      :client_secret => CONFIG['github']['secret'],
      :per_page      => 100)
  end

  attr_reader :client

  def commits project
    client.commits project.full_name
  end

  def repository_info project
    if project.github_id.present?
      client.get "/repositories/#{project.github_id}"
    else
      client.repo full_name
    end
  end

  def repository_url project
    "https://github.com/#{project.full_name}"
  end

  def source_repository_url project
    "https://github.com/#{project.source_full_name}"
  end
end
