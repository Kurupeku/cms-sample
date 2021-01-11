class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show]

  # POST /comments
  def create
    @comment = Comment.new comment_params
    set_request_informations
    if @comment.save
      redirect_to article_path(id: params[:article_id]), flash: { success: t('notice.create_comment') }
    else
      redirect_to article_path(id: params[:article_id]), flash: { error: t('notice.failed_to_create_comment') }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit :user_id, :article_id, :parent_id, :author_name, :content, :status
  end

  def set_request_informations
    @comment.analysis_request_informations request
  end
end
