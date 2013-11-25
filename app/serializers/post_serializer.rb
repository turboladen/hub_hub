class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body
  embed :ids
  has_one :spoke
end
