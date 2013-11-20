class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :spoke

  validates_presence_of :title, :body, :spoke
  validates_length_of :title, in: 2..100
  validates_length_of :body, maximum: 4000
end
