class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => I18n.t('errors.access_denied')
  end

  private

  def load_project(project)
    if project.is_a? Project
      @project = project
    else
      @project = Project.where(id: project).first
    end
    unless @project
      flash[:error] = I18n.t('errors.project_not_found')
      redirect_to projects_path
    end
  end
end
