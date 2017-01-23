class Trainer::StatisticsController < ApplicationController
  include FilterData

  before_action :authorize
  before_action :load_statistic_view
  before_action :load_filter, only: :show

  def show
    add_breadcrumb_index "statistics"
    template = "trainer/statistics/#{params[:type]}"
    if template_exists? template
      render template
    else
      raise ActionController::RoutingError.new "Not Found"
    end
  end

  def create
    respond_to do |format|
      format.js
    end
  end

  private
  def load_statistic_view
    @statistics = "Supports::Statistics::#{params[:type].classify}Support"
      .constantize.new location_ids: params[:location_ids],
      check: params[:check_visit], trainee_type_ids: params[:trainee_type_ids],
      start_date: params[:start_date], end_date: params[:end_date],
      stage_ids: params[:stage_ids]
  end
end
