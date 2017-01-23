class VotePolicy < ApplicationPolicy
  include PolicyObject

  def destroy?
    @user.voted_for? @record
  end
end
