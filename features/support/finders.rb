def find_project(name)
  project = Project.where(full_name: "example/#{name}").first
  project or raise "Project #{name.inspect} not found"
end
