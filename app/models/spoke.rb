class Spoke < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :name, :description

  validates :name, presence: true

  has_many :posts, dependent: :destroy

  friendly_id :name, use: :slugged
end
