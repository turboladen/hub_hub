require 'uri'


class Post < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers

  after_create do
    self.tweet
  end

  attr_accessible :content, :title

  belongs_to :spoke
  delegate :name, :description, :slug, to: :spoke, prefix: true

  belongs_to :user
  delegate :name, :first_name, :last_name, :email, to: :user, prefix: true

  validates :title, presence: true
  validates :content, presence: true
  validates :spoke_id, presence: true
  validates_length_of :title, in: 2..100
  validates_length_of :content, maximum: 4000

  acts_as_commentable
  acts_as_votable
  make_flaggable :inappropriate, :favorite

  LIMITER = 25

  scope :newest, order('created_at DESC')
  scope :most_active, where('commentable_count > 0').order('commentable_count DESC')
  scope :most_negative,
    where('cached_votes_down > 0').order('cached_votes_down DESC')
  scope :most_positive, where('cached_votes_up > 0').order('cached_votes_up DESC')
  scope :most_voted, where('cached_votes_total > 0').order('cached_votes_total DESC')

  # All Posts from the last 24 hours.
  def self.last_24_hours
    now = Time.now
    where('created_at >= :twenty_four_hours_ago AND created_at < :now',
      twenty_four_hours_ago: (now - 86400), now: now)
  end

  # List of possible ways to sort posts.
  def self.sort_options
    %w[newest most_active most_positive most_negative most_voted]
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

  # @todo Figure out how to not pass +host+ into the URLHelper.
  def tweet
    if Rails.env.production? && self.persisted?
      msg = %Q{#{self.spoke.name}: #{truncate(self.title, length: 121, omission: '...')} }
      msg << spoke_post_url(self.spoke_id, self, host: 'chat.mindhub.org')
      Twitter.update(msg)
    else
      false
    end
  end
end
