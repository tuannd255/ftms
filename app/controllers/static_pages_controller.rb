class StaticPagesController < ApplicationController
  def home
    if current_user.present?
      if current_user.current_role_type == "admin"
        redirect_to admin_root_path
      elsif current_user.current_role_type == "trainer"
        redirect_to trainer_root_path
      else
        @user_course = current_user.user_courses.find {|user_course| user_course
          .progress?} || current_user.user_courses.last
        add_breadcrumb @user_course.course.name, @user_course if @user_course
      end
    end
    @supports = Supports::StaticPageSupport.new
  end
end
