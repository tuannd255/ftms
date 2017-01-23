class Trainer::OrganizationChartsController < ApplicationController
  before_action :authorize

  def index
    @locations = Location.includes :manager
    add_breadcrumb_index "organization_charts"
  end
end
