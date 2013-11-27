class ChangeUserToOwnerOnPost < ActiveRecord::Migration
  def change
    remove_index :posts, :user_id
    remove_column :posts, :user_id, :integer

    add_column :posts, :owner_id, :integer
    add_index :posts, :owner_id
  end
end
