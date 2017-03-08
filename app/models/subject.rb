class Subject < ApplicationRecord
  include OrderScope

  acts_as_paranoid

  mount_uploader :image, ImageUploader

  SUBJECT_ATTRIBUTES_PARAMS = [:name, :description, :content, :image, :during_time,
    documents_attributes: [:id, :title, :document_link, :_destroy],
    task_masters_attributes: [:id, :name, :description, :_destroy],
    subject_detail_attributes: [:id, :number_of_question, :time_of_exam,
    :min_score_to_pass, :percent_of_questions, :category_questions, :_destroy]]

  has_one :subject_detail, dependent: :destroy
  has_many :task_masters, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :documents, as: :documentable
  has_many :notifications, as: :trackable, dependent: :destroy
  has_many :subject_categories, dependent: :destroy
  has_many :categories, through: :subject_categories
  has_many :subject_kick_offs, dependent: :destroy
  has_many :user_subjects, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :during_time, presence: true, numericality: {greater_than: 0}
  validate :check_require_subject_detail

  scope :subject_not_start_course, ->course{where "id NOT IN (SELECT subject_id
    FROM course_subjects WHERE course_id = ? AND status <> 0)", course.id}

  accepts_nested_attributes_for :task_masters, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:name].blank?}
  accepts_nested_attributes_for :documents, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:document_link].blank?}
  accepts_nested_attributes_for :subject_detail, allow_destroy: true

  delegate :name, to: :user_subject, prefix: true, allow_nil: true
  delegate :number_of_question, :min_score_to_pass, :time_of_exam,
    to: :subject_detail, prefix: true, allow_nil: true

  def check_require_subject_detail
    if subject_detail.present?
      errors.add :number_question,
        I18n.t("subjects.error.number_question") if subject_detail.number_of_question.blank?
      errors.add :time_of_exam,
        I18n.t("subjects.error.time_of_exam") if subject_detail.time_of_exam.blank?
      errors.add :min_score,
        I18n.t("subjects.error.min_score") if subject_detail.min_score_to_pass.blank?
    end
  end
end
