class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :first_name, :last_name, :admin, :banned,
    :remember_me_token
  has_many :posts
  embed :ids
end
