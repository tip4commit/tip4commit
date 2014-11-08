
def create_github_project project_name
  if (@github_project_1.present? && (project_name.eql? @github_project_1.full_name)) ||
     (@github_project_2.present? && (project_name.eql? @github_project_2.full_name))
    raise "duplicate project_name '#{project_name}'"
  elsif @github_project_3.present?
    raise "the maximum of three test projects already exist"
  end

# @current_project is also assigned in the "regarding the .. project named ..." step
  @current_project = Project.create! :full_name       => project_name , # e.g. "me/my-project"
                                     :github_id       => Digest::SHA1.hexdigest(project_name) ,
                                     :bitcoin_address => 'mq4NtnmQoQoPfNWEPbhSvxvncgtGo6L8WY'
  if    @github_project_2.present? ; @github_project_3 = @current_project ;
  elsif @github_project_1.present? ; @github_project_2 = @current_project ;
  else                               @github_project_1 = @current_project ;
  end
end

def create_bitbicket_project project_name
  raise "unknown service" # nyi
end

When /^regarding the "(.*?)" project named "(.*?)"$/ do |service , project_name|
# @current_project is also assigned in create_github_project and create_bitbucket_project

  @current_project = find_project service , project_name
end

def service_do service , method_dict
=begin e.g.
  service_do 'github' , {'github'    => lambda {create_github_project    project_name} ,
                         'bitbucket' => lambda {create_bitbicket_project project_name} }
=end
  (method_dict.has_key? service)? method_dict[service].call : (raise "unknown service")
end

Given(/^a "(.*?)" project named "(.*?)" exists$/) do |service , project_name|
  service_do service , {'github'    => lambda {create_github_project    project_name} ,
                        'bitbucket' => lambda {create_bitbicket_project project_name} }
end

Given(/^the project collaborators are:$/) do |table|
  @collaborators = []
  table.raw.each do |collaborator_name,|
    @collaborators << collaborator_name unless @collaborators.include? collaborator_name
  end
end

Given(/^the project collaborators are loaded$/) do
  @current_project.reload
  @current_project.collaborators.each(&:destroy)
  @collaborators.each do |name,|
    @current_project.collaborators.create!(login: name)
  end
end

When /^the project syncs with the remote repo$/ do
  # in the real world a project has no information regarding commits
  #     nor collaborators until the worker thread initially fetches the repo
  #     so we cache new_commits and collaborators and defer loading to this step
  #     which is intended to simulate the BitcoinTipper::work method
  project_owner_name = (@current_project.full_name.split '/').first
  @new_commits     ||= {@current_project.id => Hash.new}
  @collaborators   ||= [project_owner_name]
  @collaborators << project_owner_name unless @collaborators.include? project_owner_name

  step 'the new commits are loaded'
  step 'the project collaborators are loaded'
end

Then /^there should (.*)\s*be a project avatar image visible$/ do |should|
  pending "this feature is implemented in PR #140 (not yet merged)"

  avatar_xpath = "//img[contains(@src, \"githubusercontent\")]"
  if should.eql? 'not '
    page.should_not have_xpath avatar_xpath
  else
    page.should have_xpath avatar_xpath
  end
end
