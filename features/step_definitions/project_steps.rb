
When /^the project syncs with the remote repo$/ do
  # in the real world a project has no information regarding commits
  #     nor collaborators until the project initially syncs
  project_owner_name = (@current_project.full_name.split '/').first
  @new_commits     ||= {@current_project.id => Hash.new}
  @collaborators   ||= [project_owner_name]
  @collaborators << project_owner_name unless @collaborators.include? project_owner_name

  step 'the new commits are loaded'
  step "the project collaborators are loaded"
end

Then /^there should (.*)\s*be a project avatar image visible$/ do |should|
  avatar_xpath = "//img[contains(@src, \"githubusercontent\")]"
  if should.eql? 'not '
    page.should_not have_xpath avatar_xpath
  else
    page.should have_xpath avatar_xpath
  end
end
