class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show]

  # GET /comments
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  def show; end

  # POST /comments
  def create
    @comment = Comment.new comment_params
    set_background_params

    if @comment.save
      redirect_to @comment, notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit :user_id, :article_id, :author_name, :content, :status
  end

  def set_request_informations
    @comment.analysis_request_informations request
  end

  def post_by_user
    @comment.check_current_user(current_user)
  end

  def set_background_params
    set_request_informations
    post_by_user
  end
end
