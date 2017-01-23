class CoursesController < ApplicationController
  before_action :authorize
  before_action :load_user_courses

  def index
    add_breadcrumb_path "courses"
  end

  private
  def load_user_courses
    @user_courses = current_user.user_courses.course_not_init
      .includes course: :language
  end
end
