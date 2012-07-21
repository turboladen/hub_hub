class HomeController < ApplicationController
  def index
    @posts = Post.last(25)
  end
end
