class RemoveNameFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :name
  end

  def down
    add_column :posts, :name, :string
  end
end
