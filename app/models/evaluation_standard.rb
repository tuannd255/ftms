class EvaluationStandard < ApplicationRecord
  acts_as_paranoid

  ATTRIBUTES_PARAMS = [:name, :min_point, :max_point]

  has_many :evaluation_check_lists
  has_many :trainee_evaluations, through: :evaluation_check_lists
  has_many :evaluation_items
  has_many :course_evaluations, dependent: :destroy
  has_many :courses, through: :course_evaluations
end
