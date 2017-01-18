module UserSubjectHelper
  def is_selected? user_subject, status
    user_subject.status == status ? "selected=selected" : ""
  end

  def url_user_subject args
    "/#{@namespace}/course_subjects/#{args[:course_subject_id]}/user_subjects/#{args[:user_subject_id]}"
  end

  def disabled_if course
    course.finish? || course.init? ? "disabled" : ""
  end
end
