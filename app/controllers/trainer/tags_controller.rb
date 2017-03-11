class Trainer::TagsController < ApplicationController
  before_action :authorize
  before_action :load_tag, only: :show
  before_action :load_supports, only: :show

  def index
    @tags = Tag.per_page_kaminari(params[:page]).per Settings.tags_per_page
  end

  def show
    @posts = if params[:id]
      Post.tagged_with params[:id]
    else
      Array.new
    end
  end

  private
  def load_supports
    @supports = Supports::TagSupport.new params: params
  end

  def load_tag
    tag = Tag.find_by name: params[:id]
    unless tag
      flash[:alert] = flash_message "not_find"
      redirect_to posts_path
    end
  end
end
