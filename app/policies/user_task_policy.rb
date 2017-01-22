class UserTaskPolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end

  def show?
    true
  end

  def update?
    @user == @record.user
  end

  def destroy?
    !@user.is_a?(Trainee) || @user == @record.user
  end
end
