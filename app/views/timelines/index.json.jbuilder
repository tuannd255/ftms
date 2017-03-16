json.timeline do
  json.type "default"
  if @user_subjects.any?
    date = @user_subjects.first.start_date || @user_subjects.first.course.start_date
    json.date @user_subjects do |user_subject|
      json.startDate l(user_subject.start_date || date, format: :timeline_js)
      date = user_subject.user_end_date || user_subject.end_date ||
        date + user_subject.subject.during_time
      json.endDate l(user_subject.user_end_date || user_subject.end_date || date,
        format: :timeline_js)
      json.headline "#{link_to user_subject.subject.name,
        [user_subject.trainee_course, user_subject.subject]}<span class='hidden'
        data-status='#{user_subject.status}'></span>"
      json.text "<div class='description'>#{user_subject.description}</div>"
      json.tag " "
      json.asset do
        image = image_url user_subject.subject.image_url ?
          user_subject.subject.image_url : "profile.png"
        if user_subject.user_tasks.any?
          list = ""
          user_subject.user_tasks.each.with_index 1 do |user_task, index|
            list << "<div class='user_task'><div class='task'
            data-finish='#{user_task.complete?}'>- #{user_task.task_name}</div></div>"
          end
        else
          list = "none"
        end
        json.thumbnail image
        json.media list
        json.credit "<span class='text-danger'>
          #{user_subject.user_tasks.complete.size} " +
          t("tasks.task_finish") + "</span><span class='text-primary'><br>#{user_subject.user_tasks.init.size} " +
          t("tasks.task_init") + "<span>"
      end
    end
  else
    json.date [0] do
      json.startDate l(Date.today, format: :timeline_js)
      json.endDate l(Date.today, format: :timeline_js)
      json.headline t "timeline.headline"
      json.text t "timeline.content"
      json.tag " "
      json.asset do
        json.media "none"
      end
    end
  end
end
