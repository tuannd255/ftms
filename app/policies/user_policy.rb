class UserPolicy < ApplicationPolicy
  include PolicyObject

  def create?
    false
  end

  def update?
    @user == @record
  end
end
