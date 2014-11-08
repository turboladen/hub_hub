class Response < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :respondable, polymorphic: true
  has_many :responses, as: :respondable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 4000 }
  validates :owner, presence: true
  validates :respondable, presence: true

  # @return [Fixnum]
  def total_nested_responses
    first_level = self.responses.count

    total = responses.map do |response|
      response.total_nested_responses
    end.inject(:+) || 0

    total + first_level
  end
end
