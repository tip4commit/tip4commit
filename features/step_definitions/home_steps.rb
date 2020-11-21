
Then(/^I should (.*)\s*see "(.*?)" in the "(.*?)" area$/) do |should, text, node_name|
  element = find_element node_name
  element.should ((should.eql? 'not ') ? (have_no_content text) : (have_content text))
end
