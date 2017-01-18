today = Time.current.to_date
@trainees.each do |trainee|
  course_id = trainee.courses.progress.first
  @user_subjects = UserSubject.full_subject trainee.id, course_id
  courses = trainee.courses
  json.array!(@user_subjects) do |user_subject|
    end_date = user_subject.end_date
    start_date = user_subject.start_date
    user_end_date = user_subject.user_end_date

    if start_date && user_end_date == nil
      if today == user_end_date
        json.color "green"
        json.title t "calendars.demo", owner: trainee.name,
          target: user_subject.name
        json.start end_date.to_date
        json.end end_date.to_date
        json.allDay true
      elsif today == end_date
        json.color "red"
        json.title t "calendars.expected_demo", owner: trainee.name,
          target: user_subject.name
        json.start end_date.to_date
        json.end end_date.to_date
        json.allDay true
      elsif end_date.between?(today, today + 7)
        json.color "blue"
        json.title t "calendars.will_demo", owner: trainee.name,
          target: user_subject.name, time: end_date
        json.start end_date.to_date
        json.end end_date.to_date
        json.allDay true
      end
    end
  end
  json.array!(courses) do |course|
    end_date_course = course.end_date.to_date
    if end_date_course.between?(today, today + 7)
      json.color "black"
      json.title t "calendars.going_finish", owner: trainee.name, target: course.name
      json.start end_date_course
      json.end end_date_course
      json.allDay true
    end
  end
end
