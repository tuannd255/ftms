class Admin::OrganizationChartsController < ApplicationController
  before_action :authorize

  def index
    @locations = Location.includes :manager
    @support = Supports::OrganizationSupport.new
    add_breadcrumb_index "organization_charts"
  end
end
