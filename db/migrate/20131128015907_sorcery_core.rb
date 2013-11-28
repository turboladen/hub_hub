class SorceryCore < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :crypted_password, :string, default: nil
    add_column :users, :salt, :string, default: nil
    add_index :users, :username
  end
end
