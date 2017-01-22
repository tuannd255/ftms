class CoursePolicy < ApplicationPolicy
  include PolicyObject

  def index?
    true
  end

  def show?
    true
  end
end
