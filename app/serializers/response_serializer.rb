class ResponseSerializer < ActiveModel::Serializer
  attributes :id, :body, :respondable_type, :respondable_id

  has_one :owner, embed: :ids
  has_many :responses, embed: :ids, include: true
end
