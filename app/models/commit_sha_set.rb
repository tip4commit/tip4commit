class CommitShaSet
  def initialize(commits)
    @commits = commits
    @commit_by_sha = {}
    @commits.each do |commit|
      @commit_by_sha[commit.sha] = commit
    end
  end

  def commit(sha)
    @commit_by_sha[sha]
  end

  def parents(sha)
    commit = commit(sha)
    return [] unless commit
    commit.parents.map(&:sha)
  end

  def merged_commits(merge_sha)
    parents = parents(merge_sha)
    return nil if parents.size != 2

    a, b = parents
    pairs = [[a, b], [b, a]]

    pairs.each do |parent, other_parent|
      merged_commits = find_commits_between(parent, other_parent)
      return merged_commits if merged_commits
    end

    nil
  end

  def find_commits_between(base, target)
    return [] if base == target

    parents(base).each do |parent|
      next unless parent
      return [base] if parent == target

      parent_result = find_commits_between(parent, target)
      return [base] + parent_result if parent_result
    end

    return nil
  end
end
