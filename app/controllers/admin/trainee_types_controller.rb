class Admin::TraineeTypesController < ApplicationController
  before_action :load_trainee_type, only: [:edit, :update, :destroy]
  before_action :authorize

  def index
    @trainee_types = TraineeType.all
    add_breadcrumb_index "trainee_types"
  end

  def new
    @trainee_type = TraineeType.new
    add_breadcrumb_path "trainee_types"
    add_breadcrumb_new "trainee_types"
  end

  def create
    @trainee_type = TraineeType.new trainee_type_params
    respond_to do |format|
      if @trainee_type.save
        flash.now[:success] = flash_message "created"
        format.html {redirect_to admin_trainee_types_path}
      else
        flash.now[:failed] = flash_message "not_created"
        format.html {render :new}
      end
      format.js
    end
  end

  def edit
    add_breadcrumb_path "trainee_types"
    add_breadcrumb @trainee_type.name
    add_breadcrumb_edit "trainee_types"
  end

  def update
    if @trainee_type.update_attributes trainee_type_params
      flash[:success] = flash_message "updated"
      redirect_to admin_trainee_types_path
    else
      flash[:failed] = flash_message "not_update"
      render :edit
    end
  end

  def destroy
    if @trainee_type.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to :back
  end

  private
  def trainee_type_params
    params.require(:trainee_type).permit TraineeType::ATTRIBUTES_PARAMS
  end

  def load_trainee_type
    @trainee_type = TraineeType.find_by id: params[:id]
    unless @trainee_type
      redirect_to admin_trainee_types_path
      flash[:alert] = flash_message "not_find"
    end
  end
end
