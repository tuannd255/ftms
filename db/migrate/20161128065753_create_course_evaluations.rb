class CreateCourseEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :course_evaluations do |t|
      t.references :course, foreign_key: true
      t.references :evaluation_standard, foreign_key: true

      t.timestamps
    end
  end
end
