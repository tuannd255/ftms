class CommentsController < ApplicationController
  before_action :authorize, except: [:edit, :update, :destroy]
  before_action :load_post
  before_action :load_comment, only: [:edit, :update, :destroy]
  before_action :load_supports, except: [:destroy, :show]
  before_action :authorize_comment, only: [:edit, :update, :destroy]

  def index
    params[:page] ||= 1
    if params[:comment_id]
      answer = Comment.find_by id: params[:comment_id]
      redirect_if_object_nil answer
      @answers = @supports.load_replies answer
      remaining = answer.children.count - params[:page]
        .to_i * Settings.qna.replies_per_page
    else
      @answers = @supports.load_answers
      remaining = @post.comments.roots.count - params[:page]
        .to_i * Settings.qna.answers_per_page
    end
    next_page = remaining > 0 ? params[:page].to_i + 1 : 0
    @data = {next_page: next_page, comment_id: params[:comment_id]}

    respond_to do |format|
      format.js
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = @post.comments.build comment_params.merge(user: current_user)
    if @comment.save
      flash.now[:success] = flash_message "created"
    else
      flash.now[:failed] = flash_message "not_created"
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @comment.update_attributes comment_params
      flash.now[:success] = flash_message "updated"
    else
      flash.now[:failed] = flash_message "not_updated"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @comment.destroy
      flash.now[:success] = flash_message "deleted"
    else
      flash.now[:failed] = flash_message "not_deleted"
    end
    respond_to do |format|
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content, :parent_id
  end

  def load_post
    @post = Post.find_by id: params[:post_id]
    redirect_if_object_nil @post
  end

  def load_comment
    @comment = @post.comments.find_by id: params[:id]
    redirect_if_object_nil @comment
  end

  def load_supports
    @supports = Supports::PostSupport.new params: params, post: @post,
      user: current_user
  end

  def authorize_comment
    authorize_with_multiple page_params.merge(record: @comment), CommentPolicy
  end
end
