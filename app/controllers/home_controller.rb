class HomeController < ApplicationController
  def index
    @sorter = if params[:sort]
      params[:sort].to_sym
    else
      :newest
    end

    @posts = Post.send @sorter
    @sort_options = Post.sort_options
    @spokes = Spoke.all

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  def tos
    #
  end
end
