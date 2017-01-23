class NotificationsController < ApplicationController
  before_action :authorize

  def index
    @user_notifications = current_user.user_notifications.order_by_time
      .per_page_kaminari(params[:page]).per Settings.per_page
  end

  def update
    notifications = current_user.user_notifications.not_seen
    notifications.update_all seen: true
    respond_to do |format|
      format.js
    end
  end
end
