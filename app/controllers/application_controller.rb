class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  include PublicActivity::StoreController
  include BreadcrumbHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: :home
  before_action :set_locale, :load_namespace, :init_feedback, :notifications

  protected
  def after_sign_in_path_for resource
    if current_user.nil?
      root_path
    elsif current_user.is_a? Admin
      admin_root_path
    elsif current_user.is_a? Trainer
      trainer_root_path
    else
      root_path
    end
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path
    end
  end

  private
  rescue_from ActiveRecord::RecordNotFound do
    flash[:alert] = flash_message "record_not_found"
    back_or_root
  end

  include ApplicationData
  include Authorize
  include LoadData

  def default_url_options options = {}
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
