class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name, :digest_email

  validates_presence_of :first_name
  validates_presence_of :last_name

  acts_as_voter
  make_flagger

  # @todo Make sure migrations exist for adding relations
  has_many :comments
  has_many :posts

  # Gets a list of all email addresses and digest_email settings for users that
  # have subscribed to the digest.
  #
  # @return [Array]
  def self.digest_list
    where('digest_email = ?', true).select([:email, :digest_email, :first_name,
      :last_name])
  end

  # @return [Array]
  def self.admin_emails
    where(admin: true).pluck(:email)
  end

  # @return [User]
  def self.super_user
    find_by_email 'admin@mindhub.org'
  end

  # The full name of the user.
  #
  # @return [String] The full name like 'Joe Blow'.
  def name
    "#{self.first_name} #{self.last_name}"
  end

  # Is the user the super user?
  #
  # @return [Boolean]
  def super_user?
    self == User.super_user
  end
end
