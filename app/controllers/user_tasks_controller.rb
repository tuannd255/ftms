class UserTasksController < ApplicationController
  before_action :load_user_task
  before_action :authorize_user_task

  def show
    respond_to do |format|
      format.js
    end
  end

  def update
    if params[:status]
      old_status = @user_task.status
      if @user_task.update_attributes status: params[:status]
        @user_task.create_activity key: "user_task.change_status",
          owner: current_user, parameters: {old_status: old_status,
          new_status: @user_task.status}
        flash.now[:success] = flash_message "updated"
      else
        flash.now[:error] = flash_message "not_updated"
      end
    elsif params[:pull_url]
      users = [@user_task.user_subject.course.trainers, @user_task.user].flatten!
      message = t "user_tasks.report_pull_request", task: @user_task.task_name,
        url: params[:pull_url]
      room_id = @user_task.user_subject.course_subject_chatwork_room_id
      @user_task.send_message_chatwork users: users, message: message, room_id: room_id
    elsif task_params[:name] || task_params[:description]
      @user_task.update_attributes task_params
    end
    load_data
    respond_to do |format|
      format.js
      format.json do
        render json: {status: 200}
      end
    end
  end

  def destroy
    user_task = UserTask.find params[:id]
    respond_to do |format|
      user_task.destroy
      format.js
      format.json do
        render json: {status: 200}
      end
    end
  end

  private
  def load_data
    @subject_supports = Supports::SubjectTraineeSupport.new subject: @user_task
      .user_subject.subject, user_course_id: @user_task.user_subject
      .user_course_id
  end

  def authorize_user_task
    authorize_with_multiple page_params.merge(record: @user_task), UserTaskPolicy
  end

  def task_params
    params.require(:task).permit :name, :description
  end
end
