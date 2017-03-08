class AddSubjectToUserSubject < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_subjects, :subject, foreign_key: true
  end
end
