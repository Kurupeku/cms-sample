class CommentsController < ApplicationController
  # POST /comments
  def create
    @comment = Comment.new comment_params
    set_request_informations
    if @comment.save
      redirect_to article_path(id: params[:article_id]), flash: { success: t('notice.create_comment') }
    else
      set_article_variables
      flash.now[:error] = t 'notice.failed_to_create_comment'
      render template: 'articles/show'
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit :user_id, :article_id, :parent_id, :author_name, :content, :status
  end

  def set_request_informations
    @comment.analysis_request_informations request
  end

  def set_article_variables
    @article = Article.published.post.find_by! slug: @comment.article_id
    @previous_article = @article.previous
    @next_article = @article.next
    @content_html = @article.content.html_safe
    @comment = @article.comments.build
    define_side_menu_models
  end
end
