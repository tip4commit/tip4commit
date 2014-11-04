Before do
  ActionMailer::Base.deliveries.clear

  # mock branches method to prevent api call
  Project.any_instance.stub(:branches).and_return(%w(master))
end

Then(/^there should be (\d+) email sent$/) do |arg1|
  ActionMailer::Base.deliveries.size.should eq(arg1.to_i)
end

When(/^the email counters are reset$/) do
  ActionMailer::Base.deliveries.clear
end

Given(/^the tip percentage per commit is "(.*?)"$/) do |arg1|
  CONFIG["tip"] = arg1.to_f
end

Given(/^our fee is "(.*?)"$/) do |arg1|
  CONFIG["our_fee"] = arg1.to_f
end

def create_github_project project_name
  if (@github_project_1.present? && (project_name.eql? @github_project_1.full_name)) ||
     (@github_project_2.present? && (project_name.eql? @github_project_2.full_name))
    raise "duplicate project_name '#{project_name}'"
  elsif @github_project_3.present?
    raise "the maximum of three test projects already exist"
  end

# @current_project is also assigned in the "considering the .. project named ..." step
  @current_project = Project.create! :full_name       => project_name , # e.g. "me/my-project"
                                     :github_id       => Digest::SHA1.hexdigest(project_name) ,
                                     :bitcoin_address => 'mq4NtnmQoQoPfNWEPbhSvxvncgtGo6L8WY'
  if    @github_project_2.present? ; @github_project_3 = @current_project ;
  elsif @github_project_1.present? ; @github_project_2 = @current_project ;
  else                               @github_project_1 = @current_project ;
  end
end

def create_bitbicket_project project_name
  raise "unknown service" # nyi
end

When /^regarding the "(.*?)" project named "(.*?)"$/ do |service , project_name|
# @current_project is also assigned in create_github_project and create_bitbucket_project

  @current_project = find_project service , project_name
end

def service_do service , method_dict
=begin e.g.
  service_do 'github' , {'github'    => lambda {create_github_project    project_name} ,
                         'bitbucket' => lambda {create_bitbicket_project project_name} }
=end
  (method_dict.has_key? service)? method_dict[service].call : (raise "unknown service")
end

Given(/^a "(.*?)" project named "(.*?)" exists$/) do |service , project_name|
  service_do service , {'github'    => lambda {create_github_project    project_name} ,
                        'bitbucket' => lambda {create_bitbicket_project project_name} }
end

Given(/^a deposit of "(.*?)" is made$/) do |deposit|
  Deposit.create!(project: @current_project, amount: deposit.to_d * 1e8, confirmations: 2)
end

def add_new_commit commit_id , author , params = {}
  raise "duplicate commit_id" if (find_new_commit commit_id).present?

  defaults = {
    sha: commit_id,
    commit: {
      message: "Some changes",
      author: {
        email: "#{author}@example.com",
      },
    },
  }

  project_id                            = @current_project.id
  @new_commits                        ||= {}
  @new_commits[project_id]            ||= {}
  @new_commits[project_id][commit_id]   = defaults.deep_merge params
end

def find_new_commit commit_id
  (@new_commits || {}).each_value do |commits|
    return commits[commit_id] unless commits[commit_id].nil?
  end

  nil
end

Given(/^a new commit "([^"]*?)" is made$/) do |arg1|
  add_new_commit arg1 , "anonymous"
end

Given(/^(\d+) new commit.? (?:is|are) made by a user named "(.*?)"$/) do |n_commits , author|
  n_commits.to_i.times do
    add_new_commit Digest::SHA1.hexdigest(SecureRandom.hex) , author
  end
end

Given(/^a new commit "(.*?)" with parent "([^"]*?)"$/) do |arg1, arg2|
  add_new_commit arg1 , "anonymous" , parents: [{sha: arg2}]
end

Given(/^a new commit "(.*?)" with parent "(.*?)" and "(.*?)"$/) do |arg1, arg2, arg3|
  add_new_commit arg1 , "anonymous" , { parents: [{sha: arg2}, {sha: arg3}], commit: {message: "Merge #{arg2} and #{arg3}"} }
end

Given(/^the author of commit "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  commit = find_new_commit(arg1)
  raise "no such commit" if commit.nil?

  commit.deep_merge!(author: {login: arg2}, commit: {author: {email: "#{arg2}@example.com"}})
end

Given(/^the message of commit "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  commit = find_new_commit(arg1)
  raise "no such commit" if commit.nil?

  commit.deep_merge!(commit: {message: arg2})
end

Given(/^the most recent commit is "(.*?)"$/) do |commit|
  @current_project.update!(last_commit: commit)
end

Then(/^the most recent commit should be "(.*?)"$/) do |arg1|
  @current_project.reload.last_commit.should eq(arg1)
end

When(/^the new commits are loaded$/) do
  raise "no commits have been assigned" if @new_commits.nil?

  [@github_project_1 , @github_project_2 , @github_project_3].each do |project|
    next if project.nil?

    project.reload
    new_commits = @new_commits[project.id].values.map(&:to_ostruct)
    project.should_receive(:new_commits).and_return(new_commits)
    project.tip_commits
  end
end

Given(/^the project holds tips$/) do
  @current_project.update(hold_tips: true)
end

Then(/^there should be no tip for commit "(.*?)"$/) do |arg1|
  Tip.where(commit: arg1).to_a.should eq([])
end

Then(/^there should be a tip of "(.*?)" for commit "(.*?)"$/) do |arg1, arg2|
  amount = Tip.find_by(commit: arg2).amount
  amount.should_not be_nil
  (amount.to_d / 1e8).should eq(arg1.to_d)
end

Then(/^the tip amount for commit "(.*?)" should be undecided$/) do |arg1|
  Tip.find_by(commit: arg1).undecided?.should eq(true)
end

Given(/^the project collaborators are:$/) do |table|
  @collaborators = []
  table.raw.each do |collaborator_name,|
    @collaborators << collaborator_name unless @collaborators.include? collaborator_name
  end
end

Given(/^the project collaborators are loaded$/) do
  @current_project.reload
  @current_project.collaborators.each(&:destroy)
  @collaborators.each do |name,|
    @current_project.collaborators.create!(login: name)
  end
end

Given(/^an illustration of the history is:$/) do |string|
  # not checked
end
