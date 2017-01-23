class Trainer::CalendarsController < ApplicationController
  before_action :authorize
  def index
    @trainees = current_user.trainees.includes :user_subjects, :courses
  end
end
