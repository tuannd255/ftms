class Course < ApplicationRecord
  include PublicActivity::Model
  include InitUserSubject
  include EstimateTime
  include OrderScope

  acts_as_paranoid
  mount_uploader :image, ImageUploader

  USER_COURSE_ATTRIBUTES_PARAMS = [user_courses_attributes: [:id, :user_id, :_destroy, :deleted_at, :type]]
  COURSE_ATTRIBUTES_PARAMS = [:name, :image, :description,
    :language_id, :location_id, :program_id,
    :start_date, :end_date, documents_attributes:
    [:id, :title, :document_link, :description, :_destroy], subject_ids: []]

  belongs_to :language
  belongs_to :location
  belongs_to :program
  belongs_to :creator, class_name: User.name, foreign_key: :creator_id

  has_many :activities, as: :trackable, class_name: "PublicActivity::Activity", dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :trainer_courses, dependent: :destroy
  has_many :trainee_courses, dependent: :destroy
  has_many :trainers, through: :trainer_courses, source: :user
  has_many :trainees, through: :trainee_courses, source: :user
  has_many :subjects, through: :course_subjects
  has_many :user_subjects, dependent: :destroy
  has_many :documents, as: :documentable
  has_many :notifications, as: :trackable, dependent: :destroy
  has_many :messages, as: :chat_room, dependent: :destroy

  validates :name, presence: true
  validates :language_id, presence: true

  before_save :assign_date

  scope :created_between, ->start_date, end_date{where("DATE(created_at) >=
    ? AND DATE(created_at) <= ?", start_date, end_date)}
  scope :finished_between, ->start_date, end_date{where("DATE(updated_at) >=
    ? AND DATE(updated_at) <= ? AND status = #{statuses[:finish]}", start_date, end_date)}
  scope :in_programs, ->program_ids{where "program_id in (?)", program_ids}

  accepts_nested_attributes_for :user_courses, allow_destroy: true
  accepts_nested_attributes_for :documents,
    reject_if: proc {|attributes| attributes["content"].blank? && attributes["id"].blank?},
    allow_destroy: true

  enum status: [:init, :progress, :finish]

  delegate :name, to: :language, prefix: true, allow_nil: true
  delegate :name, to: :location, prefix: true, allow_nil: true
  delegate :name, to: :program, prefix: true, allow_nil: true
  delegate :name, to: :creator, prefix: true, allow_nil: true

  def start_course current_user
    update_attributes status: :progress
    user_courses.update_all status: :progress
    create_activity key: "course.start_course", owner: current_user
  end

  def finish_course current_user
    update_attributes status: :finish
    user_courses.progress.update_all status: :finish
    update_current_progress = FalseCurrentProgressService.new self
    update_current_progress.perform
    create_activity key: "course.finish_course", owner: current_user
  end

  private
  def assign_date
    self.end_date ||= estimate_end_date Settings.working_days
  end
end
