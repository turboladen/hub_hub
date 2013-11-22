class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :timeoutable

  # The full name of the user.
  #
  # @return [String] The full name like 'Joe Blow'.
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
