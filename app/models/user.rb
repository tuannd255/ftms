class User < ApplicationRecord
  acts_as_paranoid
  acts_as_reader
  mount_uploader :avatar, ImageUploader

  QUERY = "users.id NOT IN (SELECT user_id
    FROM user_courses, courses WHERE user_courses.course_id = courses.id
    AND (courses.status = 0 OR courses.status = 1)
    AND user_courses.deleted_at IS NULL
    AND courses.id <> :course_id)"


  ATTRIBUTES_PROFILE_PARAMS = [
    :id, :start_training_date, :leave_date, :finish_training_date,
    :ready_for_project, :contract_date, :naitei_company,
    :user_type_id, :university_id, :programming_language_id, :user_progress_id,
    :status_id, :location_id, :graduation, :working_day
  ]

  ATTRIBUTES_PARAMS = [:name, :email, :password,
    :password_confirmation, :avatar, :trainer_id, role_ids: [],
    profile_attributes: ATTRIBUTES_PROFILE_PARAMS]

  USER_ATTRIBUTES_PARAMS = [:name, :password, :password_confirmation, :avatar,
    profile_attributes: [:working_day, :graduation, :university]]

  attr_accessor :current_role

  belongs_to :trainer, class_name: User.name, foreign_key: :trainer_id
  belongs_to :role

  has_one :location
  has_many :user_courses, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :course_subjects, through: :user_subjects
  has_many :tasks, through: :user_tasks
  has_one :profile, dependent: :destroy
  has_one :evaluation, dependent: :destroy
  has_many :trainees, class_name: User.name, foreign_key: :trainer_id
  has_many :notes, dependent: :destroy
  has_many :notifications
  has_many :user_notifications, dependent: :destroy
  has_many :senders, class_name: Conversation.name, foreign_key: :sender_id,
    dependent: :destroy
  has_many :receivers, class_name: Conversation.name, foreign_key: :receiver_id,
    dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :feed_backs, dependent: :destroy
  has_many :track_logs, dependent: :destroy
  has_many :filters, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :user_functions, dependent: :destroy
  has_many :functions, through: :user_functions

  validates :name, presence: true, uniqueness: true
  validates_confirmation_of :password

  scope :available_of_course, ->course_id{
    joins(:profile).where QUERY, course_id: course_id
  }
  scope :trainee_roles, ->{joins(user_roles: :role)
    .where("roles.role_type = ?", Role.role_types[:trainee])}
  scope :trainers, ->{joins(user_roles: :role)
    .where("roles.role_type = ?", Role.role_types[:trainer])}
  scope :admin_roles, ->{joins(user_roles: :role)
    .where("roles.role_type = ?", Role.role_types[:admin])}
  scope :trainees, ->{trainee_roles.where.not(id: admin_roles.map(&:id))}
  scope :find_course, ->course{joins(:user_courses)
    .where("user_courses.course_id in (?)", course).distinct}
  scope :show_members, ->{limit Settings.number_member_show}
  scope :select_all, ->{includes(:user_roles).distinct}
  scope :not_trainees, ->{joins(user_roles: :role)
    .where("roles.role_type != ?", Role.role_types[:trainee]).distinct}
  scope :by_location, ->location_id{
    joins(:profile).where("profiles.location_id = ?", location_id)
  }
  scope :created_between, ->start_date, end_date{where("DATE(created_at) >=
    ? AND DATE(created_at) <= ?", start_date, end_date)}
  scope :by_trainer, ->trainer_id{where trainer_id: trainer_id}
  scope :free_trainees, -> do
    where.not(id: joins(:user_subjects)
      .where("user_subjects.status = ?", UserSubject.statuses[:progress])
      .pluck(:id))
  end
  scope :free_group, ->{where.not id: GroupUser.select(:user_id)}
  scope :free_and_in_group, ->group_id{where.not id: GroupUser
    .where.not(group_id: group_id).select(:user_id)}
  scope :users_in_course, ->{joins(:user_courses)
    .where("user_courses.deleted_at": nil).distinct}

  before_validation :set_password

  accepts_nested_attributes_for :profile

  delegate :id, :name, to: :role, prefix: true, allow_nil: true
  delegate :total_point, :current_rank, to: :evaluation, prefix: true, allow_nil: true
  delegate :location_id, to: :profile, prefix: true, allow_nil: true
  delegate :name, to: :user_task, prefix: true, allow_nil: true
  delegate :working_day, to: :profile, prefix: true, allow_nil: true
  delegate :graduation, to: :profile, prefix: true, allow_nil: true

  devise :database_authenticatable, :rememberable, :trackable, :validatable,
    :recoverable

  def total_done_tasks user, course
    done_tasks = UserSubject.load_user_subject(user.id, course.id).map(&:user_tasks).flatten.count
  end

  def owner_course course
    return course.user_courses.find_by(supervisor_id: self.id) ? true :false
  end

  def leader_course course
    return course.user_courses.find_by(leader_id: self.id) ? true :false
  end

  %w(admin trainee trainer).each do |user_type|
    define_method "is_#{user_type}?" do
      if current_role.present?
        current_role.include? eval("Settings.namespace_roles.#{user_type}")
      else
        check_role eval("Role.role_types[:#{user_type}]")
      end
    end
  end

  def in_course? course
    user_courses.exists? course_id: course
  end

  def current_progress
    user_subjects.find {|user_subject| user_subject.current_progress?}
  end

  def has_role? role_name
    self.roles.map(&:name).include? role_name
  end

  def functions
    functions = []
    self.roles.each do |role|
      functions += role.functions.pluck(:model_class, :action)
    end
    functions
  end

  def has_function? controller_name, action
    functions.each do |function|
      return true if (function.last == action &&
        function.first == controller_name)
    end
    return false
  end

  private
  def check_role role_type
    roles.exists? role_type: role_type
  end

  def set_password
    if new_record?
      self.password = Settings.default_password
      self.password_confirmation = Settings.default_password
    end
  end

  def password_required?
    new_record? ? super : false
  end
end
