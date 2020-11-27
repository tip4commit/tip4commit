# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_path, alert: I18n.t('errors.access_denied')
  end

  before_action :load_locale

  private

  def load_locale
    locale = locale_from_params || session[:locale] || locale_from_http_accept_language
    I18n.locale = session[:locale] = locale

    redirect_back(fallback_location: root_path) if params[:locale].present?
  end

  def locale_from_params
    return unless params[:locale]
    return unless ::Rails.application.config.available_locales.include?(params[:locale])

    params[:locale].to_sym
  end

  def locale_from_http_accept_language
    http_accept_language.compatible_language_from(::Rails.application.config.available_locales)&.to_sym
  end

  def load_project(params)
    return unless (is_via_project = is_a? ProjectsController) ||
                  (is_via_tips     = is_a? TipsController) ||
                  (is_via_deposits = is_a? DepositsController)

    is_standard_path    = params[:id].present? && is_via_project
    is_association_path = params[:project_id].present?
    is_pretty_path      = params[:service].present? && params[:repo].present?
    return unless is_standard_path || is_association_path || is_pretty_path

    if (is_standard_path || is_association_path) &&
       (project_id = is_via_project ? params[:id] : params[:project_id]) &&
       (@project   = (Project.where id: project_id).first)
      if    is_via_tips
        redirect_to project_tips_pretty_path     @project.host, @project.full_name
      elsif is_via_deposits
        redirect_to project_deposits_pretty_path @project.host, @project.full_name
      end
    elsif is_pretty_path
      @project = Project.where(host: params[:service])
                        .where('lower(`full_name`) = ?', params[:repo].downcase).first
    end

    if @project.nil?
      flash[:error] = I18n.t('errors.project_not_found')
      redirect_to projects_path
    end
  end

  def load_user(params)
    return unless (is_via_user = is_a? UsersController) ||
                  (is_via_tips = is_a? TipsController)

    return unless (is_standard_path    = params[:id].present? && is_via_user) ||
                  (is_association_path = params[:user_id].present?) ||
                  (is_pretty_path      = params[:nickname].present?)

    if (is_standard_path || is_association_path) &&
       (user_id = (is_via_user && params[:id]) ||
                  (is_via_tips && params[:user_id])) &&
       (@user = User.where(id: user_id).first)
      redirect_to user_tips_pretty_path @user.nickname if is_via_tips
    elsif is_pretty_path
      @user = User.where('lower(`nickname`) = ?', params[:nickname].downcase).first
    end

    if @user.nil?
      flash[:error] = I18n.t('errors.user_not_found')
      redirect_to users_path
    end
  end
end
