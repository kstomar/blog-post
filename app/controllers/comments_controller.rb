class CommentsController < ApplicationController
  before_action :find_blog_post
  before_action :find_comment, only: %i[edit update destroy]

  def create
    @comment = @blog_post.comments.build(comment_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @comment.save
        format.turbo_stream { render turbo_stream: turbo_stream.replace('blog_post_comment_form', partial: 'comments/form', locals: { comment: Comment.new, blog_post: @blog_post }) }
        format.html { render partial: 'comments/form', locals: { comment: Comment.new, blog_post: @blog_post } }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('blog_post_comment_form', partial: 'comments/form', locals: { comment: @comment, blog_post: @blog_post }) }
        format.html { render partial: 'comments/form', locals: { comment: @comment, blog_post: @blog_post } }
      end
    end
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def find_blog_post
    @blog_post = BlogPost.find(params[:blog_post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
