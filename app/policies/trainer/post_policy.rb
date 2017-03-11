class Trainer::PostPolicy < ApplicationPolicy
  include TrainerPolicyObject

  def destroy?
    @record.user.trainer == @user
  end
end
