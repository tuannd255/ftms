class ExamPolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end

  def show?
    !@user.is_a?(Trainee) || @user == @record.user
  end

  def update?
    !@user.is_a?(Trainee) || @user == @record.user
  end
end
