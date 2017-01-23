class UserCoursePolicy < ApplicationPolicy
  include PolicyObject

  def show?
    @user == @record.user
  end
end
