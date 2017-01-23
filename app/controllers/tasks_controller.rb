class TasksController < ApplicationController
  before_action :authorize, except: [:update]
  before_action :load_task, only: [:update, :destroy]
  before_action :load_user_subject_in_course, only: [:edit, :update, :destroy]
  before_action :load_user_course, only: [:edit, :destroy]
  before_action :authorize_task, only: [:update]

  def create
    @task = Task.new task_params
    authorize_task
    load_user_subject_in_course
    if @task.save
      flash.now[:success] = flash_message "created"
    else
      flash.now[:failed] = flash_message "not_created"
    end
    @user_task = user_task
    load_data
    respond_to do |format|
      format.js
    end
  end

  def update
    @old_status = user_task.status
    if @task.update_attributes task_params
      flash.now[:success] = flash_message "updated"
    else
      flash.now[:failed] = flash_message "not_updated"
    end
    @user_task = user_task
    load_data
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize_with_multiple page_params.merge(record: user_task), UserTaskPolicy
    if @task.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deteletd"
    end
    redirect_to :back
  end

  private
  def task_params
    params.require(:task).permit Task::ATTRIBUTES_PARAMS
  end

  def load_user_subject_in_course
    @user_subject = UserSubject.find_by user: current_user,
      course_subject: @task.course_subject
  end

  def load_user_course
    @course_subject = @task.course_subject
    @user_course = current_user.user_courses.find_by course_id: @course_subject.course_id
  end

  def user_task
    @task.user_tasks.take
  end

  def authorize_task
    authorize_with_multiple page_params.merge(record: @task), TaskPolicy
  end

  def load_data
    @subject_supports = Supports::SubjectTraineeSupport.new subject: @user_task
      .user_subject.subject, user_course_id: @user_task.user_subject
      .user_course_id
  end
end
