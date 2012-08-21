class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title

  belongs_to :spoke
  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :content, presence: true
  validates_length_of :title, maximum: 100
  validates_length_of :content, maximum: 4000

  acts_as_commentable
  acts_as_votable

  LIMITER = 25

  def root_comments
    self.comment_threads.where(parent_id: nil)
  end

  def self.most_active
    #Post.where('comment_threads > 0').last(LIMITER)
    #Post.where('comments > 0').last(LIMITER)
    most_voted
  end

  def self.most_negative
    Post.where('cached_votes_down > 0').order('cached_votes_down DESC').last(LIMITER)
  end

  def self.most_positive
    Post.where('cached_votes_up > 0').order('cached_votes_up DESC').last(LIMITER)
  end

  def self.most_voted
    Post.where('cached_votes_total > 0').order('cached_votes_total DESC').last(LIMITER)
  end
end
