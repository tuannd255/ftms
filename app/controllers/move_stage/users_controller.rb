class MoveStage::UsersController < ApplicationController
  before_action :authorize
  before_action :find_user, except: [:index, :new, :create]

  def edit
    add_breadcrumb @user.name, [:admin, @user]
    add_breadcrumb_edit "users"
    @user_form = UserForm.new user: @user, profile: @user.profile
    @supports = Supports::StageSupport.new(profile: @user.profile,
      stage: @user.profile.stage, user_form: @user_form) if params[:id]
  end

  def update
    @user_form = UserForm.new user: @user, profile: @user.profile
    @user_form.assign_attributes user_params
    if @user_form.save
      sign_in(@user, bypass: true) if current_user? @user
      flash[:success] = flash_message "updated"
      if current_user.is_a? Admin
        redirect_to admin_training_managements_path
      else
        redirect_to trainer_training_managements_path
      end
    else
      load_profile
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:alert] = flash_message "not_find"
      back_or_root
    end
  end
end
