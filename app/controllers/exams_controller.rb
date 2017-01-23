class ExamsController < ApplicationController
  before_action :authorize, except: [:show, :update]
  before_action :find_exam, only: [:show, :update]
  before_action :load_exams, only: :index

  def index
    add_breadcrumb_path "exams"
  end

  def show
    authorize_with_multiple page_params.merge(record: @exam), ExamPolicy
    check_status
    add_breadcrumb_path "exams"
    add_breadcrumb @exam.id
  end

  def update
    authorize_with_multiple page_params.merge(record: @exam), ExamPolicy
    if @exam.user_subject.subject.subject_detail_min_score_to_pass.nil?
      flash[:danger] = t "error.something_went_wrong"
      redirect_to exams_path
    elsif @exam.update_attributes exam_params
      user_subject = @exam.user_subject
      if params["finish"].nil?
        flash[:notice] = t "exams.saved"
        @exam.update_attributes status: :testing, spent_time: spent_time
        redirect_to [user_subject.trainee_course, user_subject.subject]
      else
        flash[:success] = t "exams.finished"
        @exam.update_attributes status: :finish, spent_time: spent_time
        point = ExamServices::CalculatePointService.new(@exam).perform
        unless point < user_subject.subject.subject_detail_min_score_to_pass
          user_subject.update_status current_user, "finish"
        end
        redirect_to exams_path
      end
    else
      flash[:danger] = t "exams.update_fail"
      redirect_to [@exam.user_subject.trainee_course, @exam.user_subject.subject]
    end
  end

  private
  def exam_params
    params.require(:exam).permit Exam::EXAM_ATTRIBUTES_PARAMS
  end

  def check_status
    if @exam.init?
      @exam.update_attributes started_at: Time.zone.now, status: :testing
      ExamFinishJob.set(wait: @exam.duration.minutes).perform_later @exam
    end
  end

  def find_exam
    @exam = Exam.includes(results: [:answer, question: :answers])
      .find_by id: params[:id]
    if @exam.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def load_exams
    @exams = current_user.exams.order_desc(:created_at).
      per_page_kaminari(params[:page]).per Settings.per_page
  end

  def spent_time
    spent_time = (Time.zone.now - @exam.started_at).to_i
    spent_time > @exam.duration.minutes.to_i ? @exam.duration.minutes.to_i : spent_time
  end
end
