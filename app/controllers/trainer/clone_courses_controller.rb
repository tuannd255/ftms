class Trainer::CloneCoursesController < ApplicationController
  before_action :load_course
  before_action :authorize

  def create
    clone_course_service = CloneCourseService.new course: @course
    @clone_course = clone_course_service.perform
    if @clone_course
      flash[:success] = t "courses.confirms.clone_success"
      redirect_to [:trainer, @clone_course]
    else
      flash[:failed] = t "courses.confirms.not_clone"
      redirect_to trainer_courses_path
    end
  end
end
