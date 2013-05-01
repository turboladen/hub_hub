class AddSlugToSpoke < ActiveRecord::Migration
  def change
    add_column :spokes, :slug, :string
    add_index :spokes, :slug, unique: true
  end
end
