class HomeController < ApplicationController
  def index
    @sort = if params[:sort]
      params[:sort].to_sym
    else
      :newest
    end

    @posts = sort_posts(@sort)
    @sort_options = sort_options
    @spokes = Spoke.all
  end

  def tos
    #
  end
end
