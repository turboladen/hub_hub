class CreateSpokes < ActiveRecord::Migration
  def change
    create_table :spokes do |t|
      t.string :name

      t.timestamps
    end
  end
end
