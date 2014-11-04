Given /^I'm signed in as "(.*?)"$/ do |nickname|
  email = "#{nickname.parameterize}@example.com"

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
    "info" => {
      "nickname"        => nickname ,
      "primary_email"   => email    ,
      "verified_emails" => [email]  ,
    },
  }.to_ostruct
  visit root_path
  first(:link, "Sign in").click
  click_on "Sign in with Github"
  page.should have_content("Successfully authenticated")

  step "a user named \"#{nickname}\" exists without a bitcoin address"
end

Given /^I'm not signed in$/ do
  visit root_path
  if page.has_content?("Sign out")
    click_on "Sign out"
    page.should have_content("Signed out successfully")
  else
    page.should have_content("Sign in")
  end
end

Given (/^I sign in as "(.*?)"$/) { |nickname| step "I'm signed in as \"#{nickname}\"" }

Given (/^I sign out$/) { step "I sign out" }

def parse_path_from_page_string page_string
  path = nil

  # explicit cases
  # e.g. "a-user/a-project github project edit"
  # e.g. "a-user user edit"
  tokens         = page_string.split ' '
  name           = tokens[0]
  model          = tokens[1]
  action         = tokens[2] || ''
  is_user        = model.eql? 'user'
  is_project     = ['github-project' , 'bitbucket-project'].include? model
  if is_project
    projects_paths = ['' , 'edit' , 'decide_tip_amounts' , 'tips' , 'deposits'] # '' => 'show'
    is_valid_path  = projects_paths.include? action
    service        = model.split('-').first
    path           = "/#{service}/#{name}/#{action}" if is_valid_path
  elsif is_user
    user_paths     = ['' , 'tips']
    is_valid_path  = user_paths.include? action
#   path           = "/users/#{name}/#{action}" if is_valid_path # TODO: nyi
    path           = "/users/#{@users[name].id}/#{action}" if is_valid_path

  # implicit cases
  else case page_string
    when 'home' ;            path = root_path ;
    when 'sign_up' ;         path = new_user_registration_path ;
    when 'sign_in' ;         path = new_user_session_path ;
    when 'users' ;           path = users_path ;
    when 'projects' ;        path = projects_path ;
    when 'search' ;          path = search_projects_path ;
    when 'tips' ;            path = tips_path ;
    when 'deposits' ;        path = deposits_path ;
    when 'withdrawals' ;     path = withdrawals_path ;
    end
  end

  path || (raise "unknown page")
end

Given(/^I visit the "(.*?)" page$/) do |page_string|
  visit parse_path_from_page_string page_string
end

Then(/^I should be on the "(.*?)" page$/) do |page_string|
  expected = parse_path_from_page_string page_string
  actual   = page.current_path

  (expected.index actual).should eq 0 # ignore trailing '/'
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
