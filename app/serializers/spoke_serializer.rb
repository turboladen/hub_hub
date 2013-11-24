class SpokeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  embed :ids
end
