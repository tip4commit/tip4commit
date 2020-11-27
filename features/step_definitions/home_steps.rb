# frozen_string_literal: true

Then(/^I should ((not)?)\s*see "(.*?)" in the "(.*?)" area$/) do |should, text, node_name|
  element = find_element node_name
  if should == 'not'
    element.should have_no_content text
  else
    element.should have_content text
  end
end
