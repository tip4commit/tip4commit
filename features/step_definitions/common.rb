Before do
  ActionMailer::Base.deliveries.clear

  # mock branches method to prevent api call
  Project.any_instance.stub(:branches).and_return(%w(master))

  @default_tip     = CONFIG["tip"]
  @default_our_fee = CONFIG["our_fee"]
  @default_min_tip = CONFIG["min_tip"]
end

After do |scenario|
  OmniAuth.config.test_mode = false

  CONFIG["tip"]     = @default_tip
  CONFIG["our_fee"] = @default_our_fee
  CONFIG["min_tip"] = @default_min_tip

  #   Cucumber.wants_to_quit = true if scenario.status.eql? :failed
  #   Cucumber.wants_to_quit = true if scenario.status.eql? :undefined
  #   Cucumber.wants_to_quit = true if scenario.status.eql? :pending
end

def mock_github_user(nickname)
  email = "#{nickname.parameterize}@example.com"

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "info" => {
      "nickname"        => nickname,
      "primary_email"   => email,
      "verified_emails" => [email],
    },
  }.to_ostruct

  step "a developer named \"#{nickname}\" exists without a bitcoin address"
end

Given /^a GitHub user named "(.*?)" exists$/ do |nickname|
  mock_github_user nickname
end

Given /^I'm signed in as "(.*?)"$/ do |nickname|
  mock_github_user nickname
  visit root_path
  first(:link, "Sign in").click
  click_on "Sign in with Github"
  page.should have_content("Successfully authenticated")
end

Given /^I'm not signed in$/ do
  visit root_path
  if page.has_content?("Sign out")
    click_on "Sign out"
    page.should have_content("Signed out successfully")
  else
    page.should have_content("Sign in")
  end

  OmniAuth.config.test_mode = false
end

Given (/^I sign in as "(.*?)"$/) { |nickname| step "I'm signed in as \"#{nickname}\"" }

Given (/^I sign out$/) { step "I'm not signed in" }

def parse_path_from_page_string(page_string)
  path = nil

  # explicit cases
  # e.g. "a-user/a-project github-project edit"
  # e.g. "a-user user edit"
  tokens     = page_string.split ' '
  name       = tokens[0]
  model      = tokens[1]
  action     = tokens[2] || '' # '' => 'show'
  is_user    = model.eql? 'user'
  is_project = ['github-project', 'bitbucket-project'].include? model
  if is_project
    projects_paths = ['', 'edit', 'decide_tip_amounts', 'tips', 'deposits']
    is_valid_path  = projects_paths.include? action
    service        = model.split('-').first
    path           = "/#{service}/#{name}/#{action}" if is_valid_path
  elsif is_user
    user_paths     = ['', 'tips']
    is_valid_path  = user_paths.include? action
    path           = "/users/#{name}/#{action}" if is_valid_path # TODO: nyi

  # implicit cases
  else case page_string
       when 'home';            path = root_path;
       when 'sign_up';         path = new_user_registration_path;
       when 'sign_in';         path = new_user_session_path;
       when 'users';           path = users_path;
       when 'projects';        path = projects_path;
       when 'search';          path = search_projects_path;
       when 'tips';            path = tips_path;
       when 'deposits';        path = deposits_path;
       when 'withdrawals';     path = withdrawals_path;
    end
  end

  path || (raise "unknown page")
end

Given(/^I visit the "(.*?)" page$/) do |page_string|
  visit parse_path_from_page_string page_string
end

Given(/^I browse to the explicit path "(.*?)"$/) do |url|
  visit url
end

Then(/^I should be on the "(.*?)" page$/) do |page_string|
  expected = parse_path_from_page_string page_string rescue expected = page_string
  actual = URI.decode(page.current_path)

  expected.chop! if (expected.end_with? '/') && (expected.size > 1)
  actual.chop! if (actual.end_with? '/') && (actual.size > 1)

  actual.should eq expected
end

def find_element(node_name)
  case node_name
  when "header"; page.find '.masthead'
  end
end

Given(/^I click "(.*?)"$/) do |arg1|
  click_on(arg1)
end

Given(/^I click "(.*?)" within the "(.*?)" area$/) do |link_text, node_name|
  within (find_element node_name) { click_on link_text }
end

Given(/^I check "(.*?)"$/) do |arg1|
  check(arg1)
end

Then(/^I should see "(.*?)"$/) do |arg1|
  page.should have_content(arg1.gsub('\n', "\n"))
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

Then(/^there should be (\d+) email sent$/) do |arg1|
  ActionMailer::Base.deliveries.size.should eq(arg1.to_i)
end

When(/^the email counters are reset$/) do
  ActionMailer::Base.deliveries.clear
end

When(/^I confirm the email address: "(.*?)"$/) do |email|
  mail      = ActionMailer::Base.deliveries.select { |ea| ea.to.first.eql? email }.first
  mail_body = mail.body.raw_source
  token     = mail_body.split('?confirmation_token=')[1].split('">Confirm my account').first
  visit "/users/confirmation?confirmation_token=#{token}"
end

Then /^some magic stuff happens in the cloud$/ do; true; end;
