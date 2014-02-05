class Response < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :respondable, polymorphic: true
  has_many :responses, as: :respondable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 4000 }
  validates :owner, presence: true
  validates :respondable, presence: true
end
