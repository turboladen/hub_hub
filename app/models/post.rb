class Post < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :spoke
  has_many :responses, as: :respondable, dependent: :destroy

  # Commenting out until Users are hooked up on front end.
  validates_presence_of :title, :body, :spoke, :owner
  validates_length_of :title, in: 2..100
  validates_length_of :body, maximum: 4000

  # Indicates whether or not this post is a link to other content or not.
  #
  # @return [Boolean]
  def link?
    #return false if self.body.include? ' '
    #self.content.match /^https?:\/\/\w+\.\w\w\w?[^\s]+$/
    !!self.body.match(URI.regexp(%w[http https]))
  end
end
