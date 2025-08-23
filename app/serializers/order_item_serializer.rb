class OrderItemSerializer
  include Alba::Resource

  attributes :id, :quantity, :price_at_time

  one :product, resource: ProductSerializer
end
