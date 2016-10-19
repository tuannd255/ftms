class Trainer::CoursesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:show, :edit]
  before_action :find_course_in_show, only: :show
  before_action :find_course_in_edit, only: :edit
  before_action :load_data, only: [:new, :show, :edit]

  def index
    respond_to do |format|
      format.html {add_breadcrumb_index "courses"}
      format.json {
        render json: CoursesDatatable.new(view_context, @namespace)
      }
    end
  end

  def new
    @course.documents.build
    add_breadcrumb_path "courses"
    add_breadcrumb_new "courses"
  end

  def create
    if @course.save
      flash[:success] = flash_message "created"
      redirect_to trainer_courses_path
    else
      flash[:failed] = flash_message "not_created"
      load_data
      render :new
    end
  end

  def show
    add_breadcrumb_path "courses"
    add_breadcrumb @course.name, :trainer_course_path
  end

  def edit
    add_breadcrumb_path "courses"
    add_breadcrumb @course.name, :trainer_course_path
    add_breadcrumb_edit "courses"
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = flash_message "updated"
      redirect_to trainer_course_path(@course)
    else
      flash[:failed] = flash_message "not_updated"
      load_data
      render :edit
    end
  end

  def destroy
    if @course.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to trainer_courses_path
  end

  private
  def course_params
    params.require(:course).permit Course::COURSE_ATTRIBUTES_PARAMS
  end

  def load_data
    @supports ||= Supports::Course.new @course
  end

  def find_course_in_show
    @course = Course.includes(:programming_language).find_by_id params[:id]
    redirect_if_object_nil @course
  end

  def find_course_in_edit
    @course = Course.includes(:documents).find_by_id params[:id]
    redirect_if_object_nil @course
  end
end
