class AddVoteCachesToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :cached_votes_total
    add_index :posts, :cached_votes_up
    add_index :posts, :cached_votes_down
  end
end
