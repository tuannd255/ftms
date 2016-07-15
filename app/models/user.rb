class User < ActiveRecord::Base

  QUERY = "id NOT IN (SELECT user_id
    FROM user_courses, courses WHERE user_courses.course_id = courses.id
    AND (courses.status = 0 OR courses.status = 1)
    AND courses.id <> :course_id) AND role_id = 3"

  mount_uploader :avatar, ImageUploader

  belongs_to :trainer, class_name: User.name, foreign_key: :trainer_id
  belongs_to :role
  belongs_to :location

  has_many :user_courses, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :course_subjects, through: :user_subjects
  has_many :tasks, through: :user_tasks
  has_one :profile, dependent: :destroy
  has_one :evaluation
  has_many :trainees, class_name: User.name
  has_many :notes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates_confirmation_of :password

  ATTRIBUTES_PARAMS = [:name, :email, :password,
    :password_confirmation, :avatar, :role_id]

  devise :database_authenticatable, :rememberable, :trackable, :validatable

  delegate :id, :name, to: :role, prefix: true, allow_nil: true

  scope :available_of_course, ->course_id{where QUERY, course_id: course_id}
  scope :find_by_role, -> role{where role: role}
  scope :trainers, ->{joins(:role).where("roles.name = 'trainer'")}
  scope :trainees, ->{joins(:role).where("roles.name = 'trainee'")}
  scope :find_by_course, ->course{joins(:user_courses)
    .where("user_courses.course_id in (?)", course).uniq}
  scope :show_members, ->{order(:role_id, :name).limit Settings.number_member_show}

  delegate :total_point, :current_rank, to: :evaluation, prefix: true, allow_nil: true

  after_create :create_user_profile, if: :is_trainee?
  before_validation :set_password

  def total_done_tasks user, course
    done_tasks = UserSubject.load_user_subject(user.id, course.id).map(&:user_tasks).flatten.count
  end

  def owner_course course
    return course.user_courses.find_by(supervisor_id: self.id) ? true :false
  end

  def leader_course course
    return course.user_courses.find_by(leader_id: self.id) ? true :false
  end

  def is_admin?
    self.role.name == "admin"
  end

  def is_trainee?
    role.name == "trainee"
  end

  def in_course? course
    user_courses.exists? course_id: course
  end

  private
  def password_required?
    new_record? ? super : false
  end

  def create_user_profile
    create_profile user_id: id
  end

  def set_password
    self.password = Settings.default_password
    self.password_confirmation = Settings.default_password
  end
end
