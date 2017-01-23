class Trainer::CourseSubjectsController < ApplicationController
  before_action :authorize
  before_action :load_course, except: :new
  before_action :load_course_subject

  def index
    @course_subjects = @course.course_subjects
  end

  def edit
    add_breadcrumb_path "courses"
    add_breadcrumb @course_subject.course_name, trainer_course_path(@course)
    add_breadcrumb @course_subject.subject_name, trainer_course_subject_path(@course,
      @course_subject.subject)
    add_breadcrumb_edit "subjects"
  end

  def update
    if @course_subject.update_attributes course_subject_params
      respond_to do |format|
        format.js do
          render nothing: true
        end
        format.html do
          flash[:success] = flash_message "updated"
          redirect_to trainer_course_subject_path @course_subject.course,
            @course_subject.subject
        end
      end
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @course_subject.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to trainer_course_path @course
  end

  private
  def course_subject_params
    params.require(:course_subject).permit CourseSubject::ATTRIBUTES_PARAMS
  end

  def load_course
    @course = Course.find_by id: params[:course_id]
    unless @course
      flash[:alert] = flash_message "not_find"
      back_or_root
    end
  end

  def load_course_subject
    @course_subject = CourseSubject.find_by id: params[:id]
    unless @course_subject
      flash[:alert] = flash_message "not_find"
      back_or_root
    end
  end
end
