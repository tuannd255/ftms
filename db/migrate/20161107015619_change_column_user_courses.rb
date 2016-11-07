class ChangeColumnUserCourses < ActiveRecord::Migration[5.0]
  def change
    rename_column :user_courses, :active, :status
    change_column :user_courses, :status, :integer, default: 0
  end
end
