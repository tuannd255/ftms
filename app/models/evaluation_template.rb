class EvaluationTemplate < ApplicationRecord
  acts_as_paranoid

  ATTRIBUTE_PARAMS = [:name, evaluation_standard_ids: []]

  has_many :evaluation_items, dependent: :destroy
  has_many :evaluation_standards, through: :evaluation_items
  has_many :trainee_evaluations, dependent: :destroy
end
