Given(/^I'm logged in as "(.*?)"$/) do |arg1|
  email = "#{arg1.parameterize}@example.com"

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "info" => {
      "nickname" => arg1,
      "primary_email" => email,
      "verified_emails" => [email],
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

Given(/^I go to the project page$/) do
  visit project_path(@project)
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

