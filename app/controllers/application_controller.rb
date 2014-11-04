class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => I18n.t('errors.access_denied')
  end

  before_filter :load_locale

  private

  def load_locale
    if params[:locale] && ::Rails.application.config.available_locales.include?(params[:locale])
      I18n.locale = session[:locale] = params[:locale].to_sym
      redirect_to :back rescue true
    elsif session[:locale]
      I18n.locale = session[:locale]
    elsif l = http_accept_language.compatible_language_from(::Rails.application.config.available_locales).to_sym rescue nil
      I18n.locale = session[:locale] = l
    end
  end

  def load_project params
    (is_project  = self.is_a? ProjectsController) ||
    (is_tips     = self.is_a? TipsController    ) ||
    (is_deposits = self.is_a? DepositsController)

    if params[:project_id].present? || params[:id].present?
      return unless project_id = (is_project               && params[:id])      ||
                                 ((is_tips || is_deposits) && params[:project_id])

      @project = Project.where(:id => project_id).first

      if is_tips
        redirect_to project_tips_pretty_path     @project.host , @project.full_name
      elsif is_deposits
        redirect_to project_deposits_pretty_path @project.host , @project.full_name
      end
    elsif params[:service].present? && params[:repo].present?
      @project = Project.where(host: params[:service]).
                         where('lower(`full_name`) = ?' , params[:repo].downcase).first
    end

    if @project.nil? && is_project
      flash[:error] = I18n.t('errors.project_not_found')
      redirect_to projects_path
    end
  end
end
