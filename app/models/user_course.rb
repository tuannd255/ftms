class UserCourse < ApplicationRecord
  include PublicActivity::Model
  include InitUserSubject
  acts_as_paranoid

  after_create :create_user_subjects_when_assign_new_user
  before_save :restore_data

  belongs_to :user
  belongs_to :course

  delegate :name, :description, :start_date, :end_date, :status,
    :programming_language, to: :course, prefix: true, allow_nil: true

  has_many :user_subjects, dependent: :destroy

  scope :course_progress, ->{joins(:course)
    .where("courses.status = ?", Course.statuses[:progress]).order :updated_at}
  scope :course_finished, ->{joins(:course)
    .where("courses.status = ?", Course.statuses[:finish])}
  scope :course_not_init, ->{joins(:course)
    .where("courses.status <> ?", Course.statuses[:init])}
  scope :find_user_by_role, ->role_id{joins(user: :user_roles)
    .where("user_roles.role_id = ?", role_id)}

  delegate :id, :name, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :course_programming_language, prefix: true, allow_nil: true

  enum status: [:init, :progress, :finish]

  private
  def create_user_subjects_when_assign_new_user
    if user.is_trainee?
      create_user_subjects [self], course.course_subjects, course_id
    end
  end

  def restore_data
    if deleted_at_changed?
      restore recursive: true
    end
  end
end
