
Then /^There should (.*)\s*be a project avatar image$/ do |should|
  avatar_xpath = "//img[contains(@src, \"githubusercontent\")]"
  if should.eql? 'not '
    page.should_not have_xpath avatar_xpath
  else
    page.should have_xpath avatar_xpath
  end
end
