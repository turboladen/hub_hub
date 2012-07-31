class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title

  belongs_to :spoke
  has_many :comments

  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates_length_of :title, maximum: 100
  validates_length_of :content, maximum: 4000

  acts_as_commentable

  def root_comments
    self.comment_threads.where(parent_id: nil)
  end
end
