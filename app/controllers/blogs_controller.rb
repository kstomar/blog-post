class BlogsController < ApplicationController
  def index
    @blogs = current_user.blogs.paginate(page: params[:page], per_page: 10)
  end

  def new
    @blog_post = Blog.new
  end


end