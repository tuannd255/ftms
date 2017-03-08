namespace :db do
  desc "Update subject for user_subject"

  task update_user_subject: :environment do
    puts "Update subject for user_subject"
    UserSubject.all.each do |user_subject|
    	user_subject.update_attribute :subject_id, user_subject.course_subject.subject_id
    end
  end
end
