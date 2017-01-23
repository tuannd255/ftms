class CommentPolicy < ApplicationPolicy
  include PolicyObject

  def create?
    !@user.is_a? Admin
  end

  def update?
    @user == @record.user
  end

  def destroy?
    !@user.is_a?(Trainee) || @user == @record.user
  end
end
