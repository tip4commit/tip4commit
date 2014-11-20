
def github_projects
  [@github_project_1 , @github_project_2 , @github_project_3].compact
end

def bitbucket_projects
  [@bitbucket_project_1 , @bitbucket_project_2 , @bitbucket_project_3].compact
end

def create_github_project project_name , is_mock_project = true
  # NOTE: when is_mock_project is false the app will actually fetch via network
  #       this is the old "find or create" GUI functionality
  #           so obviously the actual repo must exist
  #       projects created in this way will not have a bitcoin_address
  #           but will have valid data such as: github_id , avatar_url ,
  #           source_full_name , description , watchers_count , language
  #       up to three of each host are cached with a reference to the most recent

  if (@github_project_1.present? && (project_name.eql? @github_project_1.full_name)) ||
     (@github_project_2.present? && (project_name.eql? @github_project_2.full_name))
    raise "duplicate project_name '#{project_name}'"
  elsif @github_project_3.present?
    raise "the maximum of three test projects already exist"
  end

  if is_mock_project
    new_project = Project.create! :full_name       => project_name , # e.g. "me/my-project"
                                  :github_id       => Digest::SHA1.hexdigest(project_name) ,
                                  :bitcoin_address => 'mq4NtnmQoQoPfNWEPbhSvxvncgtGo6L8WY'
  else
    new_project = Project.find_or_create_by_url project_name # e.g. "me/my-project"
  end

  unless github_projects.include? new_project
    if    @github_project_2.present? ; @github_project_3 = new_project ;
    elsif @github_project_1.present? ; @github_project_2 = new_project ;
    else                               @github_project_1 = new_project ;
    end
  end

  new_project
end

def create_bitbicket_project project_name
  raise "unknown provider" # nyi
end

def find_project service , project_name
  project = Project.where(:host => service , :full_name => project_name).first
  project || (raise "Project '#{project_name.inspect}' not found")
end

Given(/^a "(.*?)" project named "(.*?)" exists$/) do |provider , project_name|
  # NOTE: project owner will be automatically added as a collaborator
  #           e.g. "seldon" if project_name == "seldon/a-project"
  #       @current_project is also assigned in step 'regarding the "..." project named "..."'
  case provider.downcase
  when 'github'
    @current_project = create_github_project    project_name
  when 'bitbucket'
    @current_project = create_bitbicket_project project_name
  when 'real-github'
    @current_project = create_github_project    project_name , false
  else raise "unknown provider \"#{provider}\""
  end

  step "the project collaborators are:" , (Cucumber::Ast::Table.new [])
end

When /^regarding the "(.*?)" project named "(.*?)"$/ do |provider , project_name|
  # NOTE: @current_project is also assigned in step 'a "..." project named "..." exists'
  @current_project = find_project provider , project_name
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
  avatar_xpath = "//img[contains(@src, \"githubusercontent\")]"
  if should.eql? 'not '
    page.should_not have_xpath avatar_xpath
  else
    page.should have_xpath avatar_xpath
  end
end
