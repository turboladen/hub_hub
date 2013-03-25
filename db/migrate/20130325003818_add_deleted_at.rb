class AddDeletedAt < ActiveRecord::Migration
  def up
    add_column :posts, :deleted_at, :datetime
    add_column :comments, :deleted_at, :datetime
  end

  def down
    remove_column :posts, :deleted_at
    remove_column :comments, :deleted_at
  end
end
