module InitUserSubject
  def create_user_subjects user_courses, course_subjects, course_id
    user_courses.to_a.product(course_subjects).each do |user_course_subject|
      user_course_subject.first.user_subjects.create(course_id: course_id,
        user_id: user_course_subject.first.user_id,
        course_subject_id: user_course_subject.second.id,
        during_time: user_course_subject.second.subject.during_time,
      	subject_id: user_course_subject.second.subject_id)
    end
  end
end
