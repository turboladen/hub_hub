module DigestMailerHelper
  def unsubscribe_message
    <<-MSG
***NOTE: If you'd like to stop receiving digest emails, login to mindhub.org,
go to your user account's profile page, click 'Edit profile', then
edit the 'Digest email' option.
    MSG
  end

  def nightly_intro
    <<-MSG
Here's your digest email of all of the posts from the past 24 hours (as of
#{Time.now.to_formatted_s(:long)}).
    MSG
  end
end
