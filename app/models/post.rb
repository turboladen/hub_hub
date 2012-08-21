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
    where('commentable_count > 0').order('commentable_count DESC').last(LIMITER)
  end

  def self.most_negative
    where('cached_votes_down > 0').order('cached_votes_down DESC').last(LIMITER)
  end

  def self.most_positive
    where('cached_votes_up > 0').order('cached_votes_up DESC').last(LIMITER)
  end

  def self.most_voted
    where('cached_votes_total > 0').order('cached_votes_total DESC').last(LIMITER)
  end
end
