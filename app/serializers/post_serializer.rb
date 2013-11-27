class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  embed :ids
  has_one :spoke
  has_one :owner, serializer: UserSerializer
end
