module Authorize
  def authorize_with_multiple args, policy
    pundit_policy = policy.new current_user, args
    query = "#{params[:action]}?"
    unless pundit_policy.public_send query
      error = Pundit::NotAuthorizedError.new "not allowed"
      raise error
    end
  end

  def authorize
    controller_name = page_params[:controller].split("/")
    policy = if controller_name.length == 1
      "#{controller_name[0].classify}Policy"
    else
      "#{controller_name[0].classify}::#{controller_name[1].classify}Policy"
    end.safe_constantize
    authorize_with_multiple page_params, policy
  end

  def page_params
    Hash[:controller, params[:controller], :action, params[:action]]
  end

  def user_not_authorized
    flash[:alert] = t "error.not_authorize"
    if current_user.is_a? Admin
      redirect_to admin_root_path
    elsif current_user.is_a? Trainer
      redirect_to trainer_root_path
    else
      redirect_to root_path
    end
  end
end
