class NotificationPolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end

  def update?
    true
  end
end
