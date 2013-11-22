module Paging
  extend ActiveSupport::Concern

  included do
    def page_limit
      limit = params[:limit] || 25

      limit.to_i
    end

    def page
      page_num = params[:page] || 1

      page_num.to_i
    end
  end
end
