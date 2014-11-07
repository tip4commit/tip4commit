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

Given(/^the tip for commit is "(.*?)"$/) do |arg1|
  CONFIG["tip"] = arg1.to_f
end

Given(/^our fee is "(.*?)"$/) do |arg1|
  CONFIG["our_fee"] = arg1.to_f
end

Given(/^min tip amount is "(.*?)"$/) do |arg1|
  CONFIG["min_tip"] = arg1.to_f * 1e8
end

Given(/^a project$/) do
  @project = Project.create!(full_name: "example/test", github_id: 123, bitcoin_address: 'mq4NtnmQoQoPfNWEPbhSvxvncgtGo6L8WY')
end

Given(/^a project "(.*?)"$/) do |arg1|
  @project = Project.create!(full_name: "example/#{arg1}", github_id: Digest::SHA1.hexdigest(arg1), bitcoin_address: 'mq4NtnmQoQoPfNWEPbhSvxvncgtGo6L8WY')
end

Given(/^a user "(.*?)" has opted\-in$/) do |arg1|
  User.find_or_create_by!(nickname: arg1) do |user|
    user.nickname = arg1
    user.password = "password"
    user.email = "#{arg1.parameterize}@example.com"
    user.skip_confirmation!
  end
end

Given(/^a deposit of "(.*?)"$/) do |arg1|
  Deposit.create!(project: @project, amount: arg1.to_d * 1e8, confirmations: 2)
end

Given(/^the last known commit is "(.*?)"$/) do |arg1|
  @project.update!(last_commit: arg1)
end

def add_new_commit(id, params = {})
  @new_commits ||= {}
  defaults = {
    sha: id,
    commit: {
      message: "Some changes",
      author: {
        email: "anonymous@example.com",
      },
    },
  }

  User.find_or_create_by(email: "anonymous@example.com") do |user|
    user.nickname = "anonymous"
    user.email = "anonymous@example.com"
    user.password = "password"
    user.skip_confirmation!
  end

  @new_commits[id] = defaults.deep_merge(params)
end

def find_new_commit(id)
  @new_commits[id]
end

Given(/^a new commit "(.*?)" with parent "([^"]*?)"$/) do |arg1, arg2|
  add_new_commit(arg1, parents: [{sha: arg2}])
end

Given(/^a new commit "(.*?)" with parent "(.*?)" and "(.*?)"$/) do |arg1, arg2, arg3|
  add_new_commit(arg1, parents: [{sha: arg2}, {sha: arg3}], commit: {message: "Merge #{arg2} and #{arg3}"})
end

Given(/^(\d+) new commits$/) do |arg1|
  arg1.to_i.times do
    add_new_commit(Digest::SHA1.hexdigest(SecureRandom.hex))
  end
end

Given(/^a new commit "([^"]*?)"$/) do |arg1|
  add_new_commit(arg1)
end

Given(/^the project holds tips$/) do
  @project.update(hold_tips: true)
end

Given(/^the message of commit "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  find_new_commit(arg1).deep_merge!(commit: {message: arg2})
end

When(/^the new commits are read$/) do
  @project.reload
  @project.should_receive(:new_commits).and_return(@new_commits.values.map(&:to_ostruct))
  @project.tip_commits
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

Then(/^the new last known commit should be "(.*?)"$/) do |arg1|
  @project.reload.last_commit.should eq(arg1)
end

Given(/^the project collaborators are:$/) do |table|
  @project.reload
  @project.collaborators.each(&:destroy)
  table.raw.each do |name,|
    @project.collaborators.create!(login: name)
  end
end

Given(/^the author of commit "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  find_new_commit(arg1).deep_merge!(author: {login: arg2}, commit: {author: {email: "#{arg2}@example.com"}})
end

Given(/^an illustration of the history is:$/) do |string|
  # not checked
end
