class ProductSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :price, :image, :category, :vegetarian, :created_at, :updated_at
end
