class Supports::Statistics::TraineeProgressSupport < Supports::Statistics::ApplicationStatistic

  def presenters
    TraineeProgressPresenter.new(trainee_by_course).render
  end

  private
  def trainee_by_course
    @load_all_trainee_by_course ||= Trainee.traine_in_education.includes(profile: [:trainee_type,
      :location, :status], trainee_courses: [:course, user_subjects: :course_subject])
  end
end
