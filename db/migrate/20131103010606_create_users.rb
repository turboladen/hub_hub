class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.boolean :banned, default: false
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :users, :email
  end
end
