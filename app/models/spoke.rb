class Spoke < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
end
