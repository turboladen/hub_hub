class AddCommentableCountToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_count, :integer, default: 0
  end
end
