class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name
  # attr_accessible :title, :body

  acts_as_voter
  make_flagger

  has_many :comments
  has_many :posts

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
