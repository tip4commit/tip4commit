# frozen_string_literal: true

def find_project(service, project_name)
  # TODO: subclass GithubProject , BitbucketProject , etc. (:host becomes :type)
  project = Project.where(:host => service, :full_name => project_name).first
  project or raise "Project '#{project_name.inspect}' not found"
end
