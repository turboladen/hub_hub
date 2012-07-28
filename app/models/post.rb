class Post < ActiveRecord::Base
  acts_as_commentable

  belongs_to :spoke
  attr_accessible :content, :name, :title

  has_many :comments

  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true

  def root_comments
    self.comment_threads.where(parent_id: nil)
  end
end
