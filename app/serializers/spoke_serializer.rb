class SpokeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  embed :ids
  has_many :posts
end
