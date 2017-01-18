module ChatworkApi extend ActiveSupport::Concern
  included do
    def send_message_chatwork args
      SentMessageChatworkJob.perform_now args
    end
  end
end
