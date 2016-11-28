class Admin::AssignEvaluationsController < ApplicationController
  before_action :authorize
  before_action :load_course, only: [:edit, :update]
  before_action :load_data, only: :edit

  def edit
    add_breadcrumb_path "courses"
    add_breadcrumb @course.name, admin_course_path(@course)
    add_breadcrumb t "courses.assign_evaluations"
  end

  def update
    if params[:course] && @course.update_attributes(course_params)
      flash[:success] = flash_message "updated"
    else
      flash[:danger] = flash_message "not_updated"
    end
    redirect_to [:admin, @course]
  end

  private
  def course_params
    params.require(:course).permit Course::COURSE_EVALUATION_ATTRIBUTES_PARAMS
  end

  def load_data
    @course_supports = Supports::CourseSupport.new course: @course
  end
end
