class FeedBacksController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @feed_back = if user_signed_in?
      current_user.feed_backs.new feed_back_params
    else
      FeedBack.new feed_back_params
    end
    if @feed_back.save
      flash.now[:success] = flash_message "created"
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def feed_back_params
    params.require(:feed_back).permit FeedBack::FEED_BACK_ATTRIBUTES_PARAMS
  end
end
