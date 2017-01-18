class SentMessageChatworkJob < ApplicationJob
  queue_as :default

  def perform args
    ChatWork.api_key = ENV["CHATWORK_API_KEY"]
    room_id = args[:room_id].to_i
    if ChatWork::Member.get(room_id: room_id).class == ChatWork::APIError
      return false
    else
      users = args[:users]
      message = args[:message]
      content = ""
      users.each {|user| content << "[To:#{user.chatwork_id}] #{user.name}\n"}
      ChatWork::Message.create room_id: room_id, body: content + message
    end
  end
end
