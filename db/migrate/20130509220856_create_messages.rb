class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :email
      t.string :name
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
