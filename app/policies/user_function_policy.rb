class UserFunctionPolicy < ApplicationPolicy
  include PolicyObject

  def update?
    @user == @record.user
  end

  def destroy?
    !@user.is_a?(Trainee) || @user == @record.user
  end
end
