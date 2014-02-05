class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :body, default: '', null: false

      t.references :owner, index: true, class_name: 'User'
      t.references :respondable, polymorphic: true, index: true

      t.integer :respondable_count, default: 0, index: true
      t.integer :cached_votes_total, default: 0, index: true
      t.integer :cached_votes_up, default: 0, index: true
      t.integer :cached_votes_down, default: 0, index: true

      t.timestamps
    end
  end
end
