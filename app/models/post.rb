require 'uri'

class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title

  belongs_to :spoke
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates_length_of :title, in: 2..100
  validates_length_of :content, maximum: 4000

  acts_as_commentable
  acts_as_votable
  make_flaggable :inappropriate, :favorite

  LIMITER = 25

  scope :newest, order('created_at')
  scope :most_active, where('commentable_count > 0').order('commentable_count DESC')
  scope :most_negative, where('cached_votes_down > 0').order('cached_votes_down DESC')
  scope :most_positive, where('cached_votes_up > 0').order('cached_votes_up DESC')
  scope :most_voted, where('cached_votes_total > 0').order('cached_votes_total DESC')

  # List of possible ways to sort posts.
  def self.sort_options
    [
      :newest,
      :most_active,
      :most_positive,
      :most_negative,
      :most_voted
    ]
  end

  # Indicates whether or not this post is a link to other content or not.
  #
  # @return [Boolean]
  def link?
    return false if self.content.include? ' '
    #self.content.match /^https?:\/\/\w+\.\w\w\w?[^\s]+$/
    self.content.match(URI.regexp(%w[http https])) ? true : false
  end

  # Helper for making CSS nicer when dynamically rendering Posts.
  #
  # @return [String] 'post'
  def item_type
    self.class.to_s.downcase
  end
end
