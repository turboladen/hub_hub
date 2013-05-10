# Used for sending emails to users.
class Message < ActiveRecord::Base

  attr_accessible :name, :email, :subject, :body

  validates :name, :email, :subject, :body, :presence => true
  validates :email, :format => { :with => %r{.+@.+\..+} }, :allow_blank => true

  def persisted?
    false
  end
end
