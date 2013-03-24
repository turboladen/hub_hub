class AddIndexes < ActiveRecord::Migration
  def up
    add_index :comments, :commentable_type
    add_index :posts, :user_id
  end

  def down
    remove_index :comments, :commentable_type
    remove_index :posts, :user_id
  end
end
