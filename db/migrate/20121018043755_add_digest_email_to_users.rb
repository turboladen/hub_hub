class AddDigestEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :digest_email, :string, default: "false"
  end
end
