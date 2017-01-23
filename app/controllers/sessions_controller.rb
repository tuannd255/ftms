class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:create, :failure]
  after_action :log_sign_in, only: :create
  before_action :log_sign_out, only: :destroy
  after_action :update_current_role, only: :create
  before_action :remove_current_role, only: :destroy
  respond_to :json

  def create
    session["user_auth"] = params[:user]
    resource = warden.authenticate!(scope: resource_name,
      recall: "#{controller_path}#failure")

    sign_in resource_name, resource
    message = I18n.t "devise.sessions.signed_in"

    yield resource if block_given?

    if request.xhr?
      return render json: {success: true,
        login: true, data: {message: message}}
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  def failure
    user = User.find_by email: session["user_auth"][:email] rescue nill
    message = I18n.t "devise.failure.invalid", authentication_keys: "email"

    respond_to do |format|
      format.json {
        render json: {success: false,
          data: {message: message, cause: "invalid"}}
      }
      format.html {
        redirect_to "/users/sessions/new"
      }
    end
  end

  private
  def log_sign_in
    current_user.track_logs.create signin_time: Time.zone.now,
      signin_ip: request.remote_ip
  end

  def log_sign_out
    log = current_user.track_logs.order_desc(:created_at).first
    log.update_attributes(signout_time: Time.zone.now) if log &&
      log.signout_time.nil?
  end

  def update_current_role
    if current_user.role_type_avaiable.any?
      current_user.update_attributes current_role_type: current_user.
        role_type_avaiable.first
    else
      current_user.update_attributes current_role_type: current_user.type.humanize.downcase
    end
  end

  def remove_current_role
    current_user.update_attributes current_role_type: nil
  end
end
