class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  include PublicActivity::StoreController

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :set_locale, except: :home
  before_action :new_feed_back
  before_action :set_current_role
  before_action :get_namespace
  before_action :set_root_path


  def default_url_options options = {}
    {locale: I18n.locale}
  end

  def authorize_with_multiple args, policy
    pundit_policy = policy.new current_user, args
    query ||= "#{params[:action]}?"
    unless pundit_policy.public_send query
      error = NotAuthorizedError.new "not allowed"
      raise error
    end
  end

  def page_params
    Hash[:controller, params[:controller], :action, params[:action],
      :user_functions, current_user.user_functions]
  end

  def load_user
    @user = User.includes(:profile).find_by id: params[:id]
    if @user.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    if @subject.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def load_task
    @task = Task.find_by id: params[:id]
    if @task.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def load_user_task
    @user_task = UserTask.find_by id: params[:id]
    if @user_task.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def load_user_subject
    @user_subject = UserSubject.find_by id: params[:id]
    if @user_subject.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  protected
  def after_sign_in_path_for resource
    get_root_path
  end

  private
  rescue_from ActiveRecord::RecordNotFound do
    flash[:alert] = flash_message "record_not_found"
    redirect_to root_url
  end

  def user_not_authorized
    flash[:alert] = t "error.not_authorize"
    redirect_to root_url
  end

  def set_current_role
    current_user.current_role ||= current_user.roles.pluck(:role_type) if current_user
  end

  def get_root_path
    if current_user.nil?
      root_path
    elsif current_user.is_admin?
      admin_root_path
    elsif current_user.is_trainer?
      trainer_root_path
    else
      root_path
    end
  end

  def set_root_path
    if current_user.nil?
    elsif current_user.is_admin? && @namespace == Settings.namespace_roles.admin
      add_breadcrumb I18n.t("breadcrumbs.paths"), "/admin"
    elsif current_user.is_trainer? && @namespace == Settings.namespace_roles.trainer
      add_breadcrumb I18n.t("breadcrumbs.paths"), "/trainer"
    else
      add_breadcrumb I18n.t("breadcrumbs.paths"), :root_path
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    User.human_attribute_name "name"
    User.human_attribute_name "email"
    User.human_attribute_name "password"
    User.human_attribute_name "password_confirmation"
    User.human_attribute_name "role"
    User.human_attribute_name "courses"
    User.human_attribute_name "course_leaders"
    Course.human_attribute_name "name"
    Course.human_attribute_name "start_date"
    Course.human_attribute_name "end_date"
    Course.human_attribute_name "status"
    Course.human_attribute_name "leaders"
    Subject.human_attribute_name "name"
    Subject.human_attribute_name "description"
    Subject.human_attribute_name "courses"
    Subject.human_attribute_name "task_masters"
  end

  def new_feed_back
    @feed_back = FeedBack.new
  end

  def get_namespace
    @namespace = self.class.parent.to_s.downcase
    @namespace = Settings.namespace_roles.trainee if @namespace == "object"
  end

  def redirect_if_object_nil object
    if object.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end
end
