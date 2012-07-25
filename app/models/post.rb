class Post < ActiveRecord::Base
  belongs_to :spoke
  attr_accessible :content, :name, :title

  has_many :comments

  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
