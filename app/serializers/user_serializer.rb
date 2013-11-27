class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :admin, :banned
  has_many :posts
  embed :ids
end
