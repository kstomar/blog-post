class BlogsController < ApplicationController
  before_action :find_blog_post, only: %i[show edit update destroy]

  def index
    @blog_posts = @blog_posts = Blog.paginate(page: params[:page]).published.desc_order
  end

  def new
    @blog_post = Blog.new
  end

  def create
    @blog_post = current_user.blogs.build(blog_post_params)

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to blog_url, notice: 'Blog post successfully created' }
      else
        format.html { render :new }
      end

      format.turbo_stream { render turbo_stream: turbo_stream.replace("blog_post_#{@blog_post.id}", partial: 'blogs/form', locals: { blog_post: @blog_post }) }
    end
  end

  def show
    @comments = @blog_post.comments.desc_order
    @comment = Comment.new
  end

  def edit; end

  def update

    if @blog_post.update(blog_post_params)
      redirect_to blog_url, notice: "Blog post successfully updated"
    else
      render :edit
    end
  end

  def my_blogs
    @blog_posts = Blog.paginate(page: params[:page]).draft.desc_order
  end

  def destroy
    @blog_post.destroy

    redirect_to blog_url, notice: 'Blog post was successfully destroyed.'
  end

  private

  def blog_post_params
    params.require(:blog).permit(:title, :content, :is_draft)
  end

  def find_blog_post
    @blog_post = Blog.find(params[:id])
  end
end
