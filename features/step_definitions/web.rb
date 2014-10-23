Given(/^I'm logged in as "(.*?)"$/) do |arg1|
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "info" => {
      "nickname" => arg1,
      "primary_email" => "#{arg1.gsub(/\s+/,'')}@example.com",
      "verified_emails" => [],
    },
  }.to_ostruct
  visit root_path
  first(:link, "Sign in").click
  click_on "Sign in with Github"
  page.should have_content("Successfully authenticated")
end

Given(/^I'm not logged in$/) do
  visit root_path
  if page.has_content?("Sign out")
    click_on "Sign out"
    page.should have_content("Signed out successfully")
  else
    page.should have_content("Sign in")
  end
end

Given(/^I go to the "(.*?)" page$/) do |page_name|
  case page_name
  when 'home'
    visit "/"
  when 'sign_up'
    visit new_user_registration_path
  when 'sign_in'
    visit new_user_session_path
  when 'projects'
    visit projects_path
  when 'project'
    visit project_path(@project)
  when 'project edit'
    visit edit_project_path(@project)
  else
    throw "unknown page_name"
  end
end

Given(/^I click on "(.*?)"$/) do |arg1|
  click_on(arg1)
end

Given(/^I check "(.*?)"$/) do |arg1|
  check(arg1)
end

Then(/^I should see "(.*?)"$/) do |arg1|
  page.should have_content(arg1)
end

Then(/^I should not see "(.*?)"$/) do |arg1|
  page.should have_no_content(arg1)
end

Given(/^I fill "(.*?)" with:$/) do |arg1, string|
  fill_in arg1, with: string
end

Given(/^I fill "(.*?)" with: "(.*?)"$/) do |text_field, string|
  fill_in text_field, with: string
end
