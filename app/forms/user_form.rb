class UserForm
  include ActiveModel::Model
  attr_accessor :user, :profile

  class << self
    def user_attributes
      User.column_names
    end

    def profile_attributes
      Profile.column_names
    end

    def model_name
      User.model_name
    end
  end

  def initialize args = {}
    @user = args[:user]
    @profile = args[:profile]
    assign_attributes args if args
  end

  user_attributes.each do |attr|
    delegate attr.to_sym, "#{attr}=".to_sym, to: :user
  end

  profile_attributes.each do |attr|
    delegate attr.to_sym, "#{attr}=".to_sym, to: :profile
  end

  delegate :id, :persisted?, to: :user

  def assign_attributes params
    user_attributes = params.slice *self.class.user_attributes
    user.assign_attributes user_attributes
    @user = @user.becomes @user.type.constantize
    profile_attributes = params.slice *self.class.profile_attributes
    profile.assign_attributes profile_attributes
    setup_associations
  end

  def assign_password params
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
  end

  validate :validate_children

  def save
    if valid?
      ActiveRecord::Base.transaction do
        user.save!
        profile.save!
      end
    end
  end

  def user
    @user ||= User.new
  end

  def profile
    @profile ||= Profile.new
  end

  private
  def setup_associations
    profile.user = user
  end

  def validate_children
    setup_associations

    if user.invalid?
      promote_errors user.errors
    end

    if profile.invalid?
      promote_errors profile.errors
    end
  end

  def promote_errors child_errors
    child_errors.each do |attribute, message|
      errors.add attribute, message
    end
  end
end
