class TraineeEvaluation < ApplicationRecord

  ATTRIBUTES_PARAMS = [:user_id, :total_point, :targetable_type,
    :targetable_id, :evaluation_template_id, 
    evaluation_check_lists_attributes: [:id, :score, :name,
      :evaluation_standard_id, :_destroy, :use]]

  belongs_to :targetable, polymorphic: true
  belongs_to :user
  belongs_to :evaluation_template

  has_many :evaluation_check_lists, dependent: :destroy
  has_many :evaluation_standards, through: :evaluation_check_lists
  has_many :notes, dependent: :destroy

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :trainer, prefix: true, allow_nil: true

  accepts_nested_attributes_for :evaluation_check_lists, allow_destroy: true,
    reject_if: proc { |attributes| attributes['score'].blank? }
end
