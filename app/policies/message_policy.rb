class MessagePolicy < ApplicationPolicy
  include PolicyObject

  def create?
    true
  end

  def update?
    @user == @record.user
  end

  def destroy?
    !@user.is_a?(Trainee) || @user == @record.user
  end
end
