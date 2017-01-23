class FilterDatasController < ApplicationController
  include FilterHelper

  before_action :load_filter, only: [:index]
  before_action :load_dates

  def index
    @type = params[:type]

    data = JSON.parse(@current_filter.content) rescue []
    @filter_field = @month.nil? ? @type : [@type, @month].join("_")
    @filter = data["list_filter_select"][@filter_field] || [] rescue []
    @key_field = :key
    @value_field = :value

    case @type
    when "trainee_name"
      @resources = Trainee.order(:name).pluck :name
    when "trainee_type"
      @key_field = :id
      @value_field = :trainee_type_name
      @resources = TraineeType.pluck(:name).sort!
    when "location"
      @key_field = :id
      @value_field = :location_name
      @resources = Location.pluck(:name).sort!
    when "graduation"
      @key_field = :graduation
      @value_field = :graduation
      @resources = []
      Profile.order(:graduation).each do |profile|
        @resources << if profile.graduation
          l profile.graduation, format: :year_month
        else
          profile.graduation
        end
      end
      @resources = @resources.uniq.compact
    when "trainee_status"
      @key_field = :id
      @value_field = :status
      @resources = Status.pluck(:name).sort!
    when "university"
      @key_field = :id
      @value_field = :universitys_name
      @resources = University.pluck(:abbreviation).sort!
    when "trainer"
      @key_field = :trainer
      @value_field = :trainer
      @resources = Trainer.pluck(:name).sort!
    when "current_progress"
      @key_field = :current_progress
      @value_field = :current_progress
      @resources = Subject.pluck(:name).sort!
    when "start_training_date"
      @key_field = :start_training_date
      @value_field = :start_training_date
      @resources = Profile.pluck(:start_training_date).uniq.compact.sort!
    when "leave_date"
      @key_field = :leave_date
      @value_field = :leave_date
      @resources = Profile.pluck(:leave_date).uniq.compact.sort!
    when "finish_training_date"
      @key_field = :finish_training_date
      @value_field = :finish_training_date
      @resources = Profile.pluck(:finish_training_date).uniq.compact.sort!
    when "contract_date"
      @key_field = :contract_date
      @value_field = :contract_date
      @resources = Profile.pluck(:contract_date).uniq.compact.sort!
    when "ready_for_project"
      @key_field = :ready_for_project
      @value_field = :ready_for_project
      @resources = Profile.pluck(:ready_for_project).uniq.compact.sort!
    when "language"
      @key_field = :id
      @value_field = :language_name
      @resources = Language.pluck(:name).sort!
    when "working_day"
      @resources = Profile.pluck(:working_day).uniq.compact.sort!
      @blank = @type == "working_day"
      @key_field = :working_day
      @value_field = :working_day
    when "course_name"
      @resources = Course.pluck(:name).sort!
    when "course_status"
      @resources = i18n_enum(:course, :status)
    when "course_trainers"
      @key_field = :trainer
      @value_field = :trainer
      @resources = Trainer.pluck(:name).sort!
    when "course_start_date"
      @key_field = :start_date
      @value_field = :start_date
      @resources = Course.pluck(:start_date).uniq.compact.sort!
    when "course_end_date"
      @key_field = :end_date
      @value_field = :end_date
      @resources = Course.pluck(:end_date).uniq.compact.sort!
    when "subject_name"
      @key_field = :subject_name
      @value_field = :subject_name
      @resources = Subject.pluck(:name).sort!
    when "exam_created_at"
      @key_field = :created_at
      @value_field = :created_at
      @resources = Exam.pluck(:created_at).uniq.compact.sort!
    when "exam_spent_time"
      @key_field = :spent_time
      @value_field = :spent_time
      @resources = Exam.pluck(:spent_time).uniq.compact.sort!
    when "exam_score"
      @key_field = :score
      @value_field = :score
      @resources = Exam.pluck(:score).uniq.compact.sort!
    when "staff_code"
      @key_field = :staff_code
      @value_field = :staff_code
      @resources = Profile.pluck(:staff_code).uniq.compact.sort!
    when "stage"
      @key_field = :id
      @value_field = :stage_name
      @resources = Stage.pluck(:name).sort!
    when "question_content"
      @key_field = :question_content
      @value_field = :question_content
      @resources = Question.pluck(:content).uniq.compact.sort!
    when "level"
      @resources = i18n_enum(:question, :level)
    when "controller_name"
      @key_field = :routes
      @value_field = :routes
      @resources = Function.select(:model_class).distinct.pluck(:model_class)
    when "category_name"
      @key_field = :category_name
      @value_field = :category_name
      @resources = Category.pluck(:name).uniq.compact.sort!
    when "away_date"
      @key_field = :away_date
      @value_field = :away_date
      @resources = Profile.pluck(:away_date).uniq.compact.sort!
    when "comeback_date"
      @key_field = :comeback_date
      @value_field = :comeback_date
      @resources = Profile.pluck(:comeback_date).uniq.compact.sort!
    when "program"
      @key_field = :program
      @value_field = :program
      @resources = Program.roots.includes :children
    when "post_title"
      @key_field = :post_title
      @value_field = :post_title
      @resources = Post.pluck(:title).uniq.compact.sort!
    when "post_views"
      @key_field = :post_views
      @value_field = :post_views
      @resources = Post.pluck(:views).uniq.compact.sort!
    when "post_content"
      @key_field = :post_content
      @value_field = :post_content
      @resources = Post.pluck(:content).uniq.compact.sort!
    when "namespace"
      @key_field = :routes
      @value_field = :routes
      @resources = load_namespace
    when "evaluation_template_name"
      @key_field = :evaluation_template_name
      @value_field = :evaluation_template_name
      @resources = EvaluationTemplate.pluck(:name).uniq.compact.sort!
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    @filter = current_user.filters.find_or_create_by filter_type: load_filter_type,
      target_id: filter_params[:target_id], target_params: filter_params[:target_params]

    respond_to do |format|
      if @filter.update_attributes(filter_params) && @filter.content
        format.json {render json: {content: JSON.parse(@filter.content)}}
      else
        format.json {render json: :fail}
      end
    end
  end

  private
  def load_filter_type
    Filter.filter_types[params[:filter][:filter_type]]
  end

  def filter_params
    params.require(:filter).permit :user_id, :content, :target_id, :is_turn_on, :target_params, :filter_type
  end

  def load_filter
    @filter_type = params[:filter_type]
    return if @filter_type.nil? || !Filter.filter_types.keys.include?(@filter_type)
    @current_filter = current_user.filters.send(@filter_type).try :first
  end

  def load_dates
    @dates = []
    @range_select = params[:range_time_values] ||
      params[:range_time_select] || params[:edit_range_time_values] ||
      Date.today.strftime("%Y-%m")
    param_date = params[:range_time_values] ||
      params[:edit_range_time_values] || params[:range_time_select]
    begin
      @dates = param_date.split(";").map{|date| Date.strptime(date,"%Y-%m")}.sort
    rescue
    end
    @dates << Date.today.beginning_of_month if @dates.blank?
  end
end
