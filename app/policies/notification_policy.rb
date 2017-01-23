class NotificationPolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end

  def update?
    @user == @record.user
  end
end
