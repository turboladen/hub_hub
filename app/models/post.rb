class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title

  belongs_to :spoke
  has_many :comments

  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true

  acts_as_commentable

  def root_comments
    self.comment_threads.where(parent_id: nil)
  end
end
