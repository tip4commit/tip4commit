class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def load_project(id)
    @project = Project.where(id: id).first
    unless @project
      flash[:error] = 'Project not found.'
      redirect_to projects_path
    end
  end
end
