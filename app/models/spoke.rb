class Spoke < ActiveRecord::Base
  attr_accessible :name, :description

  validates :name, presence: true

  has_many :posts, dependent: :destroy
end
