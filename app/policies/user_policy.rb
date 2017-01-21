class UserPolicy < ApplicationPolicy
  include PolicyObject

  def show?
    true
  end

  def update?
    !@user.is_a?(Trainee) || @user == @record
  end
end
