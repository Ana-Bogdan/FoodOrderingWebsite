class ProductSerializer
  include Alba::Resource

  attributes :id, :name, :price, :image, :category, :vegetarian, :created_at, :updated_at
end
