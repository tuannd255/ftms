class Trainer::TaskMastersController < ApplicationController
  before_action :authorize
  before_action :find_subject, only: :index

  def index
    @task_masters = @subject.task_masters
    add_breadcrumb_path "subjects"
    add_breadcrumb @subject.name
    add_breadcrumb_subject_task_masters
  end

  private
  def find_subject
    @subject = Subject.includes(:documents, :task_masters)
      .find_by id: params[:subject_id]
    if @subject.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to trainer_subjects_path
    end
  end
end
