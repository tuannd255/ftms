class Trainer::DashboardController < ApplicationController
  before_action :authorize

  def index
    add_breadcrumb_index "dashboard"
    @dashboard_support = Supports::Dashboard.new
  end
end
