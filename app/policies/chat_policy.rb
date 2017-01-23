class ChatPolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end
end
