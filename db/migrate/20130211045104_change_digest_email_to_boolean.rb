class ChangeDigestEmailToBoolean < ActiveRecord::Migration
  def change
    change_column :users, :digest_email, :boolean, default: false
  end
end
