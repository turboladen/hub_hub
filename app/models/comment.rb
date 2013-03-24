class Comment < ActiveRecord::Base
  attr_accessible :body

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  acts_as_votable

  validates_presence_of :body
  validates_presence_of :user

  belongs_to :commentable, polymorphic: true, counter_cache: :commentable_count
  belongs_to :user

  make_flaggable :inappropriate

  scope :last_24_hours, where('created_at >= :twenty_four_hours_ago AND created_at < :now',
    twenty_four_hours_ago: (Time.now - 86400), now: Time.now)

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    c = self.new
    c.commentable_id = obj.id
    c.commentable_type = obj.class.base_class.name
    c.body = comment
    c.user_id = user_id

    c
  end

  def post
    Post.find(self.commentable_id)
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(commentable_type: commentable_str.to_s, commentable_id: commentable_id).
      order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id.
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  def item_type
    self.class.to_s.downcase
  end

  def make_child_of(comment_id)
    parent_comment = Comment.find(comment_id.to_i)
    self.move_to_child_of(parent_comment)

    save
  end
end
