
Then(/^I should (.*)\s*see "(.*?)" in the header$/) do |should , text|
  if should.eql? 'not '
    page.find('.masthead').should have_no_content(text)
  else
    page.find('.masthead').should have_content(text)
  end
end
