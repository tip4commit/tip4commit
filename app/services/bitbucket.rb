require 'sawyer'

class Bitbucket
  Repository = Struct.new :id, :name, :full_name, :source_full_name, :description, :watchers_count, :language

  Changeset = Struct.new :sha, :commit, :author
  Commit    = Struct.new :author, :message, :commiter
  Committer = Struct.new :date
  Author    = Struct.new :email, :name

  attr_reader :agent

  def initialize
    @agent = Sawyer::Agent.new("https://bitbucket.org")
  end

  def repository_info(repository)
    data = request :get, repository_path(repository.full_name)

    Repository.new(
      data.slug,
      data.name,
      repository.full_name,
      (data.fork_of.owner + "/" + data.fork_of.slug rescue ''),
      data.description,
      data.followers_count,
      data.language
    )
  end

  def collaborators_info(project)
    # TODO
    []
  end

  def branches(project)
    # TODO
    ['master']
  end

  def commits(repository)
    # todo use repository.branch
    data = request :get, changesets_path(repository.full_name)

    data.changesets.map do |cs|
      author_pieces = cs.raw_author.match(/^(.*) <(.*@.*)>$/)

      date   = DateTime.parse(cs.utctimestamp)
      author = Author.new(author_pieces[2], author_pieces[1])
      commit = Commit.new(author, cs.message, Committer.new(date))
      Changeset.new(cs.raw_node, commit)
    end
  end

  def repository_url(project)
    "https://bitbucket.org/#{project.full_name}"
  end

  def source_repository_url(project)
    "https://bitbucket.org/#{project.source_full_name}"
  end

  def commit_url(project, commit)
    "https://bitbucket.org/#{project.full_name}/commits/#{commit}"
  end

  protected

  def repository_path(full_name)
    "#{base_path}#{full_name}"
  end

  def changesets_path(full_name)
    "#{base_path}#{full_name}/changesets?limit=15"
  end

  def base_path
    "/api/1.0/repositories/"
  end

  def request(method, path)
    agent.call(method, path).data
  end
end
