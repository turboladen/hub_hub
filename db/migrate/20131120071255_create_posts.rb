class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :user, index: true
      t.references :spoke, index: true
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0

      t.timestamps
    end
  end
end
