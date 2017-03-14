class Admin::TraineeEvaluationsController < ApplicationController
  include FilterData
  before_action :authorize
  before_action :find_trainee_evaluation, only: [:edit, :update]
  before_action :load_data, except: [:index, :create, :update]
  before_action :check_trainee_evaluation, only: :new

  def index
    add_breadcrumb_index "trainee_evaluations"
    @trainee_evaluation_supports = Supports::TraineeEvaluationSupport.new namespace:
      @namespace, filter_service: load_filter, current_user: current_user
  end

  def new
    add_breadcrumb_path "trainee_evaluations"
    add_breadcrumb @supports.targetable.user_name,
      [:admin, @supports.targetable.user]
    add_breadcrumb_new "trainee_evaluations"
    if params[:evaluation_template_id] 
      render json: @supports.evaluation_template.evaluation_standards 
    end
  end

  def create
    @trainee_evaluation = TraineeEvaluation.new trainee_evaluation_params
    if @trainee_evaluation.save
      flash[:success] = flash_message "created"
      redirect_to [:admin, :trainee_evaluations]
    else
      load_data
      flash[:alert] = flash_message "not_created"
      render :new
    end
  end

  def edit
    add_breadcrumb_path "trainee_evaluations"
    add_breadcrumb @supports.targetable.user_name,
      [:admin, @supports.targetable.user]
    add_breadcrumb_edit "trainee_evaluations"
  end

  def update
    if @trainee_evaluation.update_attributes trainee_evaluation_params
      flash[:success] = flash_message "updated"
      redirect_to [:admin, :trainee_evaluations]
    else
      load_data
      flash[:alert] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def trainee_evaluation_params
    params.require(:trainee_evaluation).permit TraineeEvaluation::ATTRIBUTES_PARAMS
  end

  def load_data
    evaluation_template = EvaluationTemplate.find_by id: params[:evaluation_template_id]
    targetable = if params[:user_subject_id]
      UserSubject.find_by id: params[:user_subject_id]
    else
      TraineeCourse.find_by id: params[:user_course_id]
    end
    if targetable
      @trainee_evaluation ||= TraineeEvaluation.new
      @supports = Supports::TraineeEvaluationSupport.new trainee_evaluation:
        @trainee_evaluation, targetable: targetable,
        evaluation_template: evaluation_template
    else
      flash[:alert] = flash_message "not_find"
      redirect_to [:admin, :trainee_evaluations]
    end
  end

  def find_trainee_evaluation
    @trainee_evaluation = TraineeEvaluation.includes(
      evaluation_check_lists: :evaluation_standard).find_by id: params[:id]
    unless @trainee_evaluation
      flash[:alert] = flash_message "not_find"
      redirect_to [:admin, :trainee_evaluations]
    end
  end

  def check_trainee_evaluation
    trainee_evaluation = TraineeEvaluation.find_by user_id: @supports
      .targetable.user_id, targetable: @supports.targetable
    if trainee_evaluation
      flash[:alert] = flash_message "has_exist"
      redirect_to [:edit, :admin, @supports.targetable, trainee_evaluation]
    end
  end
end
