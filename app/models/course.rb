class Course < ActiveRecord::Base
  include RailsAdminCourse
  include PublicActivity::Model
  include InitUserSubject
  tracked only: [:finish_course, :start_course],
    owner: ->(controller, model) {controller.current_user}

  validates :name, presence: true, uniqueness: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :check_day_present, on: [:create, :update]
  validate :check_end_date, on: [:create, :update]

  has_many :course_subjects, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :subjects, through: :course_subjects

  has_many :course_leaders, class_name: UserCourse.name,
                            dependent: :destroy,
                            foreign_key: :course_id,
                            inverse_of: :course
  has_many :leaders, through: :course_leaders

  has_many :course_supervisors, class_name: UserCourse.name,
                                dependent: :destroy,
                                foreign_key: :course_id,
                                inverse_of: :course
  has_many :supervisors, through: :course_supervisors

  enum status: [:init, :progress, :finish]

  def create_user_subjects_when_start_course
    create_user_subjects user_courses, course_subjects, id, false
  end

  def create_course_owner user
    course_supervisors.create supervisor_id: user.id, course_id: id, leader_id: user.id
  end

  def check_day_present
    self.errors.add :start_date, I18n.t("error.wrong_date") if 
      self.start_date.to_date < Date.today
  end

  def check_end_date
    errors.add :end_date, I18n.t("error.wrong_end_date") if
      self.end_date < self.start_date
  end
end
