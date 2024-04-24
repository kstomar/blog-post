class BlogsController < ApplicationController
  before_action :set_blog_post, only: %i[show edit update destroy]

  def index
    @blogs = Blog.paginate(page: params[:page]).published.latest
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = current_user.blogs.build(blog_post_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog), notice: 'Blog post successfully created' }
      else
        format.html { render :new }
      end

      format.turbo_stream { render turbo_stream: turbo_stream.replace("blog_post_#{@blog.id}", partial: 'blogs/form', locals: { blog_post: @blog }) }
    end
  end

  def show
    @comments = @blog.comments.latest
    @comment = Comment.new
  end

  def edit; end

  def update
    if @blog.update(blog_post_params)
      redirect_to blog_url, notice: "Blog post successfully updated"
    else
      render :edit
    end
  end

  def my_blogs
    @blogs = Blog.where(user_id: current_user.id).paginate(page: params[:page]).latest
  end

  def destroy
    @blog.destroy

    redirect_to blog_url, notice: 'Blog post was successfully destroyed.'
  end

  private

  def blog_post_params
    params.require(:blog).permit(:title, :content, :is_draft)
  end

  def set_blog_post
    @blog = Blog.find(params[:id])
  end
end
