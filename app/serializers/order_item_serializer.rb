class OrderItemSerializer
  include JSONAPI::Serializer

  attributes :id, :quantity, :price_at_time

  belongs_to :product, serializer: ProductSerializer
end
