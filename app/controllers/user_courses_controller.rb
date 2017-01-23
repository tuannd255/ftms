class UserCoursesController < ApplicationController
  before_action :find_user_course, only: :show

  def show
    add_breadcrumb_path "courses"
    add_breadcrumb @trainee_course.course.name
    authorize_with_multiple page_params.merge(record: @user_course), CoursePolicy
    @supports = Supports::TraineeCourseSupport.new @trainee_course
  end

  private
  def find_user_course
    @trainee_course = TraineeCourse.includes(course: [:trainers, :trainees]).find_by id: params[:id]
    if @trainee_course.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to courses_path
    end
  end
end
