class SubjectPolicy < ApplicationPolicy
  include PolicyObject

  def update?
    @user == @record.user
  end
end
