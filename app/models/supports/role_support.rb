class Supports::RoleSupport
  attr_reader :role

  def initialize role
    @role = role
  end

  def presenter form
    @role_allocate_function_presenters_admin ||= AllocateFunctionPresenter.new(
      namespace: @namespace, role: @role, form: form, routes: routes).render
  end

  def routes
    routes = []
    Function.pluck(:model_class, :action).group_by(&:first).values.map{|e|
      e.flatten.uniq}.each{|x| routes << Hash[:controller, x.shift, :actions, x]}
    routes
  end
end
