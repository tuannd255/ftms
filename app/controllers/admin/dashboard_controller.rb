class Admin::DashboardController < ApplicationController
  before_action :authorize

  def index
    authorize_with_multiple page_params, Admin::UserFunctionPolicy
    @dashboard_support = Supports::Dashboard.new
    add_breadcrumb_index "dashboard"
  end
end
