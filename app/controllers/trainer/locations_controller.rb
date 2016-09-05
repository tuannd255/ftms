class Trainer::LocationsController < ApplicationController
  load_and_authorize_resource
  before_action :load_managers, except: :destroy

  def index
    respond_to do |format|
      format.html {add_breadcrumb_index "locations"}
      format.json {
        render json: LocationsDatatable.new(view_context, @namespace)
      }
    end
  end

  def show
    @manager = @location.manager
    @trainers = User.trainers.by_location @location.id

    add_breadcrumb_path "locations"
    add_breadcrumb @location.name
  end

  def new
    add_breadcrumb_path "locations"
    add_breadcrumb_new "locations"
  end

  def create
    if @location.save
      flash[:success] = flash_message "created"
      redirect_to trainer_locations_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def edit
    add_breadcrumb_path "locations"
    add_breadcrumb @location.name
    add_breadcrumb_edit "locations"
  end

  def update
    if @location.update_attributes location_params
      flash[:success] = flash_message "created"
      redirect_to trainer_locations_path
    else
      flash[:failed] = flash_message "not_created"
      render :edit
    end
  end

  def destroy
    if @location.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to trainer_locations_path
  end

  private
  def location_params
    params.require(:location).permit :name, :user_id
  end

  def load_managers
    @managers = User.not_trainees
  end
end
