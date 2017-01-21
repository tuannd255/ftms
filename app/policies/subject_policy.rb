class SubjectPolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end

  def show?
    true
  end

  def update?
    !@user.is_a?(Trainee) || @user == @record.user
  end
end
