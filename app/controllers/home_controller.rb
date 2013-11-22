class HomeController < ApplicationController
  include Paging

  def index
    @posts = Post.includes(:spoke, :user).page(page).per(page_limit)

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  def tos
  end

  def faq
  end
end
