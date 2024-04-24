class CommentsController < ApplicationController
  before_action :set_blog_post
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = @blog_post.comments.build(comment_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @comment.save
        @comment.broadcast_prepend_to(
          [@blog_post, :comments],
          target: "blog_post_#{@blog_post.id}_comments",
          locals: { current_user: current_user, comment: @comment, blog_post: @blog_post }
        )

        format.turbo_stream {
          render turbo_stream: [turbo_stream.replace('blog_post_comment_form', partial: 'comments/new', locals: { comment: Comment.new, blog_post: @blog_post }),
                                turbo_stream.prepend("blog_#{@blog_post.id}_comments", partial: 'comments/comment', locals: { comment: @comment, blog_post: @blog_post })]
        }
        format.html { render partial: 'comments/form', locals: { comment: Comment.new, blog_post: @blog_post } }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('blog_post_comment_form', partial: 'comments/new', locals: { comment: @comment, blog_post: @blog_post }) }
        format.html { render partial: 'comments/form', locals: { comment: @comment, blog_post: @blog_post } }
      end
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("blog_post_#{@comment.id}", partial: 'comments/comment', locals: { comment: @comment, blog_post: @blog_post }) }

        format.html { redirect_to blog_url }
      end
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("blog_post_#{@comment.id}") }
      format.html { redirect_to blog_url }
    end
  end

  private

  def set_comment
    @comment = @blog_post.comments.find(params[:id])
  end

  def set_blog_post
    @blog_post = Blog.find_by(id: params[:blog_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
