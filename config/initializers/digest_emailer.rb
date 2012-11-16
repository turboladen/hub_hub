if ActiveRecord::Base.connection.table_exists? 'settings'
  Settings.digest_email ||= {}
  Settings.digest_email[:send_time] ||= "8:30am"
end
