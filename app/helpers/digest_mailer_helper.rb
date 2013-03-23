module DigestMailerHelper
  def unsubscribe_message(format)
    if format == :html
      msg = "Note: If you'd like to stop receiving digest emails, go to "
      msg << link_to('your account profile page', edit_user_registration_url)
      msg << ", then edit the 'Digest email' option."

      msg
    else
      <<-MSG
***NOTE: If you'd like to stop receiving digest emails, login to chat.mindhub.org,
go to your user account's profile page, click 'Edit profile', then
edit the 'Digest email' option.
      MSG
    end
  end

  def nightly_intro
    <<-MSG
Here's your digest email of all of the posts from the past 24 hours (as of
#{Time.now.to_formatted_s(:long)}).
    MSG
  end
end
