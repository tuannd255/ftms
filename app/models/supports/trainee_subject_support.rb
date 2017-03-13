class Supports::TraineeSubjectSupport
  attr_reader :subject, :args

  def initialize args
    @user_subject = args[:user_subject]
    @user_course = args[:user_course]
  end

  def course_subject
    @course_subject ||= CourseSubject.find_by course: course, subject: subject
  end

  def project
    @project ||= course_subject.project
  end

  def course_subject_requirements
    @course_subject_requirements ||= course_subject.course_subject_requirements
  end

  def course
    @course ||= @user_course.course
  end

  def user_subject
    @user_subject 
  end

  def subject
    @subject ||= user_subject.subject
  end

  def trainers
    @trainers ||= members.collect{|member| member.user if member.is_a? TrainerCourse}.reject!{|t| t.nil?}
  end

  def trainees
    @trainees ||= members.collect{|member| member.user if member.is_a? TraineeCourse}.reject!{|t| t.nil?}
  end

  def users
    @user ||= members.take Settings.number_member_show
  end

  def member_size
    @member_size ||= members.size
  end

  def count_member
    @count_member ||= member_size - Settings.number_member_show
  end

  def user_tasks
    @user_tasks ||= user_subject.user_tasks.includes :task, :user
  end

  def task_statuses
    @task_statuses ||= UserTask.statuses
  end

  def task_new
    @task_new ||= Task.new
  end

  def user_task_handle
    @user_task_handle ||= task_new.user_tasks.build
  end

  def user_course
    @user_course 
  end

  UserTask.statuses.each do |key, value|
    define_method "number_of_task_#{key}" do
      instance_variable_set "@number_of_task_#{key}", 
        user_tasks.select{|user_task| user_task.send("#{key}?")}.size
    end
  end

  def user_tasks_chart_data
    unless user_subject.init?
      @user_tasks_chart_data = {}

      course_subject.user_subjects.includes(:user, :user_tasks).each do |user_subject|
        @user_tasks_chart_data[user_subject.user_name] = user_subject.user_tasks
          .select{|user_task| user_task.complete?}.size
      end
      @user_tasks_chart_data
    end
  end

  def exam_process
    user_subject.exams.last
  end

  def show_kick_off?
    @has_kickoff ||= user_subject.subject.subject_kick_offs.any?
    if user_subject.progress? && !user_subject.is_viewed? && @has_kickoff
      user_subject.set_view_kick_off
      true
    else
      false
    end
  end

  private
  def members
    @members ||= course.user_courses
  end
end
