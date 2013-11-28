class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :posts, foreign_key: 'owner_id'

  validates_confirmation_of :password
  validates_presence_of :password, on: :create
  validates_presence_of :email, :username
  validates_uniqueness_of :email, :username

  # The full name of the user.
  #
  # @return [String] The full name like 'Joe Blow'.
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
