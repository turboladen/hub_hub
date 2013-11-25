class HomeController < ApplicationController
  include Paging
  respond_to :json

  def index
  end
end
