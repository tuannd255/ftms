class VotesController < ApplicationController
  before_action :authorize, except: :destroy
  before_action :check_voteable, only: [:create, :destroy]

  def create
    @voteable.send "#{vote_params[:type]}_by", current_user
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize_with_multiple page_params.merge(record: @voteable), VotePolicy
    @voteable.send "unvote_by", current_user
    respond_to do |format|
      format.js
    end
  end

  private
  def vote_params
    params.require(:vote).permit :type
  end

  def check_voteable
    model = [Post, Comment].detect {|object| params["#{object.name.underscore}_id"]}
    @voteable = model.find_by id: params["#{model.name.underscore}_id"] if model
    redirect_if_object_nil @voteable
  end
end
