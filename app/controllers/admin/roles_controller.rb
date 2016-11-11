class Admin::RolesController < ApplicationController
  before_action :authorize
  before_action :load_role, only: [:edit, :update, :destroy]
  before_action :load_routes, only: [:new, :edit]

  def index
    respond_to do |format|
      format.html {add_breadcrumb_index "roles"}
      format.json {
        render json: RolesDatatable.new(view_context, @namespace)
      }
    end
  end

  def new
    @role = Role.new
    add_breadcrumb_path "roles"
    add_breadcrumb_new "roles"
  end

  def create
    @role = Role.new role_params
    if @role.save
      flash[:success] = flash_message "created"
      redirect_to admin_roles_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def edit
    add_breadcrumb_path "roles"
    add_breadcrumb @role.name
    add_breadcrumb_edit "roles"
  end

  def update
    if @role.update_attributes role_params
      flash[:success] = flash_message "updated"
      redirect_to admin_roles_path
    else
      flash[:failed] = flash_message "not_update"
      render :edit
    end
  end

  def destroy
    if @role.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to :back
  end

  private
  def role_params
    params.require(:role).permit Role::ATTRIBUTES_ROLE_PARAMS
  end

  def load_role
    @role = Role.find_by id: params[:id]
    unless @role
      redirect_to admin_roles_path
      flash[:alert] = flash_message "not_find"
    end
  end

  def load_routes
    @routes = []
    temp = Rails.application.routes.set.anchored_routes.map(&:defaults)
      .reject {|route| route[:internal] || check_route(route[:controller])}

    temp.pluck(:controller).uniq.each do |controller|
      @routes << Hash["controller".to_sym, controller, "actions".to_sym,
        temp.select {|route| route[:controller] == controller}.pluck(:action).uniq]
    end
    @routes
  end

  def check_route route
    Settings.controller_names.each do |object|
      return true if route.include? object
    end
    false
  end
end
