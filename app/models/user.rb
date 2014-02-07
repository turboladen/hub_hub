class User < ActiveRecord::Base
  has_secure_password

  has_many :posts, foreign_key: 'owner_id'
  has_many :responses, as: :respondable, foreign_key: 'owner_id'

  before_save { self.email = email.downcase }
  before_create do
    generate_token(:auth_token)
    generate_token(:remember_token)
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password,
    on: :create,
    length: { minimum: 6 },
    presence: true,
    confirmation: true

  # The full name of the user.
  #
  # @return [String] The full name like 'Joe Blow'.
  def name
    "#{self.first_name} #{self.last_name}"
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
