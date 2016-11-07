class Notifications::UserCourseNotificationBroadCastJob < ApplicationJob
  queue_as :default

  def perform args
    notification = args[:course].notifications.create key: args[:key],
      user_id: args[:user].id, parameters: args[:parameters]

    args[:user_ids].each do |user_id|
      notification.user_notifications.create user_id: user_id
    end
    notify_content = "#{I18n.t "layouts.course"} #{args[:user].name}
      #{I18n.t "notifications.keys.#{notification.key}",
      data: notification.trackable.name} #{I18n.t "statuses.#{args[:parameters]}"}"

    BroadCastService.new(notification, "channel_user_subject_#{args[:course].id}",
      notify_content).broadcast
  end
end
