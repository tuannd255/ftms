class SubjectsController < ApplicationController
  before_action :load_user_course
  before_action :load_subject

  def show
    authorize_with_multiple page_params.merge(record: @subject), SubjectPolicy
    @subject_supports = Supports::SubjectTraineeSupport.new subject: @subject,
      user_course_id: params[:user_course_id]
    add_breadcrumb_path "courses"
    add_breadcrumb @subject_supports.user_course.course.name,
      @subject_supports.user_course
    add_breadcrumb @subject.name
  end

  private
  def load_user_course
    @user_course = current_user.user_courses.find_by id: params[:user_course_id]
    redirect_if_object_nil @user_course
  end

  def load_subject
    user_subject = @user_course.user_subjects
      .find_by subject_id: params[:id]
    if user_subject
      @subject = user_subject.subject
    else
      flash[:alert] = flash_message "not_find"
      redirect_to @user_course
    end
  end
end
