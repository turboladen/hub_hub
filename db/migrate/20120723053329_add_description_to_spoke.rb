class AddDescriptionToSpoke < ActiveRecord::Migration
  def change
    add_column :spokes, :description, :text
  end
end
