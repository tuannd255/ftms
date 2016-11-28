class Supports::CourseSupport
  attr_reader :course, :program, :current_user

  def initialize args
    @current_user = args[:current_user]
    @course = args[:course]
    @namespace = args[:namespace]
    @program = args[:program]
    @filter_service = args[:filter_service]
  end

  def course_subjects
    @course_subjects ||= @course.course_subjects.includes(:subject).order_position
  end

  %w(trainees trainers).each do |objects|
    define_method objects do
      instance_variable_set "@#{objects}",
        @course.send("#{objects}").users_in_course
    end
  end

  def assigned_user_ids
    @assigned_user_ids ||= @course.user_courses.map &:user_id
  end

  def trainees_assign
    @trainees_assign ||= User.trainees.available_of_course @course.id
  end

  def trainers_assign
    @trainers_assign ||= Role.includes(:users, :user_roles)
      .find_by(name: Settings.roles.trainer).users
  end

  %w(trainee trainer).each do |object|
    define_method "#{object}_courses_handler" do
      instance_variable_set "@#{object}_courses_handler",
        (
          send("#{object}s_assign").map do |user|
            UserCourse.unscoped.find_or_initialize_by user.class.name.underscore
              .to_sym => user, course: @course
          end
        )
    end
  end

  def subjects
    @subjects ||= Subject.all
  end

  %w(programming_languages locations programs).each do |objects|
    define_method objects do
      instance_variable_set "@#{objects}",
        objects.classify.constantize.all.collect {|object| [object.name,
        object.id]}
    end
  end

  def courses
    @courses = if @program
      @program.courses.includes :programming_language, :location
    elsif @current_user
      @current_user.courses.includes :programming_language, :location, :program
    else
      Course.includes :programming_language, :location, :program
    end
  end

  def filter_data_user
    @filter_data_user ||= @filter_service.user_filter_data
  end

  def course_presenters
    @course_presenters ||=  CoursePresenter.new(courses: courses,
      namespace: @namespace, program: @program).render
  end

  def evaluation_standards
    @evaluation_standards = EvaluationStandard.all
  end

  def check_evaluation f, id
    f.object.course_evaluations.map(&:evaluation_standard_id).include? id
  end
end
