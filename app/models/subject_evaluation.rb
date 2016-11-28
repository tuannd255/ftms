class SubjectEvaluation < ApplicationRecord
  belongs_to :subject
  belongs_to :evaluation_standard
end
