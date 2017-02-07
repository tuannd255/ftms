class SubjectServices::InitCourseSubjectService
  include InitUserSubject

  attr_reader :course_subject

  def initialize course_subject
    @course_subject = course_subject
    @trainee_courses = course_subject.course.trainee_courses
    @subject = course_subject.subject
  end

  def perform
    update_subject_course
    init_user_subjects
    create_tasks
  end

  private
  def update_subject_course
    @course_subject.update_attributes subject_name: @subject.name,
      subject_description: @subject.description,
      subject_content: @subject.content, image: @subject.image
  end

  def init_user_subjects
    create_user_subjects @trainee_courses, [@course_subject], @course_subject.course_id
  end

  def create_tasks
    @subject.task_masters.each do |task_master|
      Task.create course_subject_id: @course_subject.id, name: task_master.name,
        description: task_master.description, task_master_id: task_master.id
    end
  end
end
