class CourseEvaluation < ApplicationRecord
  belongs_to :course
  belongs_to :evaluation_standard
end
