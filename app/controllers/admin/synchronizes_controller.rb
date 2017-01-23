class Admin::SynchronizesController < ApplicationController
  before_action :authorize
  before_action :init_google_drive, only: [:index]

  def index
    store_request_link params[:link] if params[:link].present?
    synchronize_data_from_google params[:code] if params[:code].present?
    store_request_titles params[:title] if params[:title].present?
  end

  private
  def init_google_drive
    @auth = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      scope: [
        Settings.sync_google.drive_url,
        Settings.sync_google.spreadsheets_url,
      ],
      redirect_uri: admin_synchronizes_url)
    @auth_url = @auth.authorization_uri
  end

  def store_request_link request_link
    $redis.set "link", request_link
    $redis.set "function", params[:function]
    redirect_to @auth_url.to_s
  end

  def synchronize_data_from_google code
    sync_google = SyncServices::SynchronizeGoogle.new code: code, auth: @auth, link: link
    method_sync = "synchronize " + function.downcase
    method_sync = method_sync.gsub(" ", "_")
    if title.blank?
      @titles = sync_google.list_sheets
    else
      if sync_google.send method_sync, title
        flash[:success] =  t "notice.sync_success", function: function
      else
        flash[:alert] = t "notice.sync_fails", function: function
      end
      $redis.del "title"
      redirect_to root_path
    end
  end

  def store_request_titles request_title
    $redis.set "title", request_title
    redirect_to @auth_url.to_s
  end

  def delete_cookies
    ["title", "function", "link"].each{|key| $redis.del key}
  end

  ["title", "function", "link"].each do |name|
    define_method name do
      $redis.get name
    end
  end
end
