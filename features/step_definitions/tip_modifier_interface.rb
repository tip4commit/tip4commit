When(/^I choose the amount "(.*?)" on commit "(.*?)"$/) do |arg1, arg2|
  within find(".decide-tip-amounts-table tbody tr", text: arg2) do
    choose arg1
  end
end

When(/^I choose the amount "(.*?)" on all commits$/) do |arg1|
  all(".decide-tip-amounts-table tbody tr").each do |tr|
    within tr do
      choose arg1
    end
  end
end

When(/^I go to the edit page of the project$/) do
  visit edit_project_path(@project)
end

When(/^I send a forged request to enable tip holding on the project$/) do
  page.driver.browser.process_and_follow_redirects(:patch, project_path(@project), project: {hold_tips: "1"})
end

Then(/^I should see an access denied$/) do
  page.should have_content("You are not authorized to perform this action!")
end

Then(/^the project should not hold tips$/) do
  @project.reload.hold_tips.should eq(false)
end

Then(/^the project should hold tips$/) do
  @project.reload.hold_tips.should eq(true)
end

Given(/^the project has undedided tips$/) do
  create(:undecided_tip, project: @project)
  @project.reload.should have_undecided_tips
end

Given(/^the project has (\d+) undecided tip$/) do |arg1|
  @project.tips.undecided.each(&:destroy)
  create(:undecided_tip, project: @project)
  @project.reload.should have_undecided_tips
end

Given(/^I send a forged request to set the amount of the first undecided tip of the project$/) do
  tip = @project.tips.undecided.first
  tip.should_not be_nil
  params = {
    project: {
      tips_attributes: {
        "0" => {
          id: tip.id,
          amount_percentage: "5",
        },
      },
    },
  }

  page.driver.browser.process_and_follow_redirects(:patch, decide_tip_amounts_project_path(@project), params)
end

When(/^I send a forged request to change the percentage of commit "(.*?)" on project "(.*?)" to "(.*?)"$/) do |arg1, arg2, arg3|
  project = find_project(arg2)
  tip = project.tips.detect { |t| t.commit == arg1 }
  tip.should_not be_nil
  params = {
    project: {
      tips_attributes: {
        "0" => {
          id: tip.id,
          amount_percentage: arg3,
        },
      },
    },
  }

  page.driver.browser.process_and_follow_redirects(:patch, decide_tip_amounts_project_path(project), params)
end

Then(/^the project should have (\d+) undecided tips$/) do |arg1|
  @project.tips.undecided.size.should eq(arg1.to_i)
end

