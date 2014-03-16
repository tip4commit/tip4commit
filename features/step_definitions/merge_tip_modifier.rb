
COIN = 1e8

Given(/^the tip for commit is "(.*?)"$/) do |arg1|
  CONFIG["tip"] = arg1.to_f
end

Given(/^our fee is "(.*?)"$/) do |arg1|
  CONFIG["our_fee"] = arg1.to_f
end

Given(/^the tip modifier for "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  CONFIG["tip_modifiers"] ||= {}
  CONFIG["tip_modifiers"][arg1] = arg2.to_f
end

Given(/^there's no tip modifier defined$/) do
  CONFIG.delete("tip_modifiers")
end

Given(/^a project$/) do
  @project = Project.create!(full_name: "example/test", github_id: 123)
end

Given(/^a deposit of "(.*?)"$/) do |arg1|
  Deposit.create!(project: @project, amount: arg1.to_d * COIN, confirmations: 1)
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

Given(/^the message of commit "(.*?)" is "(.*?)"$/) do |arg1, arg2|
  find_new_commit(arg1).deep_merge!(commit: {message: arg2})
end

When(/^the new commits are read$/) do
  @project.should_receive(:new_commits).and_return(@new_commits.values.map(&:to_ostruct))
  @project.tip_commits
end

Then(/^there should be no tip for commit "(.*?)"$/) do |arg1|
  Tip.where(commit: arg1).to_a.should eq([])
end

Then(/^there should a tip of "(.*?)" for commit "(.*?)"$/) do |arg1, arg2|
  (Tip.find_by(commit: arg2).amount.to_d / COIN).should eq(arg1.to_d)
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
  find_new_commit(arg1).deep_merge!(author: {login: arg2})
end

Given(/^an illustration of the history is:$/) do |string|
  # not checked
end
