class MessagePolicy < ApplicationPolicy
  include PolicyObject

  def destroy?
    @user == @record.voter
  end
end
