namespace :db do
  desc "Update subject for user_subject"

  task update_user_subject: :environment do
    puts "Update subject for user_subject"
    UserSubject.all.each do |user_subject|
    	user_subject.update_attribute :subject_id, user_subject.course_subject.subject_id
    end

    puts "Update user course"
    UserCourse.all.each do |user_course|
      user_course.update_attribute status: "finish" if user_course.course.finish?
    end
  end
end
