class UsersController < ApplicationController
  before_action :load_university, only: :edit
  before_action :find_user
  before_action :authorize_user
  before_action :load_data, only: :show

  def show
    add_breadcrumb @user.name
  end

  def edit
    @user_form = UserForm.new user: @user, profile: @user.profile
    add_breadcrumb @user.name, :user_path
    add_breadcrumb_edit "users"
  end

  def update
    @user_form = UserForm.new user: @user, profile: @user.profile
    @user_form.assign_attributes user_params
    @user_form.assign_password user_params
    if @user_form.save
      @user.update_attributes avatar: user_params[:avatar] if user_params[:avatar]
      sign_in @user, bypass: true
      if current_user.is_a? Admin
        redirect_to [:admin, @user], notice: flash_message("updated")
      elsif current_user.is_a? Trainer  
        redirect_to [:trainer, @user], notice: flash_message("updated")
      else
        redirect_to @user, notice: flash_message("updated")
      end
    else
      load_university
      flash[:alert] = flash_message "not_updated"
      add_breadcrumb @user.name, :user_path
      add_breadcrumb_edit "users"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def load_data
    @supports ||= Supports::UserSupport.new @user
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def authorize_user
    authorize_with_multiple page_params.merge(record: @user), UserPolicy
  end

  def load_university
    @universities = University.all
  end
end
