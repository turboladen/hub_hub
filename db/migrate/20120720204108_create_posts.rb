class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.string :title
      t.text :content
      t.references :spoke

      t.timestamps
    end
    add_index :posts, :spoke_id
  end
end
