class AddCommentableCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :commentable_count, :integer, default: 0
  end
end
