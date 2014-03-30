class Project < ActiveRecord::Base
  has_many :deposits # todo: only confirmed deposits that have amount > paid_out
  has_many :tips, inverse_of: :project
  accepts_nested_attributes_for :tips
  has_many :collaborators, autosave: true

  has_one :tipping_policies_text, inverse_of: :project
  accepts_nested_attributes_for :tipping_policies_text

  validates :full_name, :github_id, uniqueness: true, presence: true
  validates :host, inclusion: [ "github", "bitbucket" ], presence: true

  def update_repository_info repo
    self.github_id = repo.id
    self.name = repo.name
    self.full_name = repo.full_name
    self.source_full_name = repo.source.full_name rescue ''
    self.description = repo.description
    self.watchers_count = repo.watchers_count
    self.language = repo.language
    self.save!
  end

  def update_collaborators(repo_collaborators)
    existing_collaborators = collaborators

    repo_logins = repo_collaborators.map(&:login)
    existing_logins = existing_collaborators.map(&:login)

    existing_collaborators.each do |existing_collaborator|
      unless repo_logins.include?(existing_collaborator.login)
        existing_collaborator.mark_for_destruction
      end
    end

    repo_collaborators.each do |repo_collaborator|
      unless existing_logins.include?(repo_collaborator.login)
        collaborators.build(login: repo_collaborator.login)
      end
    end

    save!
  end

  def repository_client
    if host.present?
      host.classify.constantize.new
    end
  end

  def github_url
    repository_client.repository_url self
  end

  def source_github_url
    repository_client.source_repository_url self
  end

  def raw_commits
    repository_client.commits self
  end

  def repository_info
    repository_client.repository_info self
  end

  def collaborators_info
    repository_client.collaborators_info self
  end

  def new_commits
    begin
      commits = Timeout::timeout(90) do
        raw_commits.
          # Filter merge request
          select{|c| !(c.commit.message =~ /^(Merge\s|auto\smerge)/)}.
          # Filter fake emails
          select{|c| c.commit.author.email =~ Devise::email_regexp }.
          # Filter commited after t4c project creation
          select{|c| c.commit.committer.date > self.deposits.first.created_at }.
          to_a
      end
    rescue Octokit::BadGateway, Octokit::NotFound, Octokit::InternalServerError,
           Errno::ETIMEDOUT, Net::ReadTimeout, Faraday::Error::ConnectionFailed => e
      Rails.logger.info "Project ##{id}: #{e.class} happened"
    rescue StandardError => e
      Airbrake.notify(e)
    end
    sleep(1)
    commits || []
  end

  def tip_commits
    new_commits.each do |commit|
      Project.transaction do
        tip_for commit
        update_attribute :last_commit, commit.sha
      end
    end
  end

  def tip_for commit
    if (next_tip_amount > 0) && !Tip.exists?(commit: commit.sha)

      user = User.find_or_create_with_commit commit
      user.update(nickname: commit.author.login) if commit.author.try(:login)

      if hold_tips
        amount = nil
      else
        amount = next_tip_amount
      end

      # create tip
      tip = tips.create({ user: user,
                          amount: amount,
                          commit: commit.sha,
                          commit_message: commit.commit.message })

      tip.notify_user

      Rails.logger.info "    Tip created #{tip.inspect}"
    end
  end

  def available_amount
    self.deposits.where("confirmations > 0").map(&:available_amount).sum - tips_paid_amount
  end

  def unconfirmed_amount
    self.deposits.where(:confirmations => 0).where('created_at > ?', 7.days.ago).map(&:available_amount).sum
  end

  def tips_paid_amount
    self.tips.select(&:decided?).reject(&:refunded?).sum(&:amount)
  end

  def tips_paid_unclaimed_amount
    self.tips.non_refunded.unclaimed.sum(:amount)
  end

  def next_tip_amount
    (CONFIG["tip"]*available_amount).ceil
  end

  def update_cache
    update available_amount_cache: available_amount
  end

  def self.update_cache
    find_each do |project|
      project.update_cache
    end
  end

  def update_info
    begin
      update_repository_info(repository_info)
      update_collaborators(collaborators_info)
    rescue Octokit::BadGateway, Octokit::NotFound, Octokit::InternalServerError,
           Errno::ETIMEDOUT, Net::ReadTimeout, Faraday::Error::ConnectionFailed => e
      Rails.logger.info "Project ##{id}: #{e.class} happened"
    rescue StandardError => e
      Airbrake.notify(e)
    end
  end

  def tips_to_pay
    tips.to_pay
  end

  def amount_to_pay
    tips_to_pay.sum(:amount)
  end

  def has_undecided_tips?
    tips.undecided.any?
  end

  def commit_url(commit)
    repository_client.commit_url(self, commit)
  end
end
