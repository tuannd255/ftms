class SubjectsController < ApplicationController
  before_action :load_user_course
  before_action :load_subject

  def show
    authorize_with_multiple page_params.merge(record: @user_subject.subject), SubjectPolicy
    @subject_supports = Supports::TraineeSubjectSupport.new user_subject: @user_subject,
      user_course: @user_course
    add_breadcrumb_path "courses"
    add_breadcrumb @user_course.course.name,
      @subject_supports.user_course
    add_breadcrumb @user_subject.subject.name
  end

  private
  def load_user_course
    @user_course = UserCourse.includes(course: [user_courses: :user])
      .find_by id: params[:user_course_id]
    redirect_if_object_nil @user_course
  end

  def load_subject
    @user_subject = current_user.user_subjects.includes(subject: [:subject_kick_offs, :subject_detail])
      .find_by subject_id: params[:id], user_course_id: @user_course.id
    unless @user_subject
      flash[:alert] = flash_message "not_find"
      redirect_to @user_course
    end
  end
end
