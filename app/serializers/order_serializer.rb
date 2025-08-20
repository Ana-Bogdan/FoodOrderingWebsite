class OrderSerializer
  include JSONAPI::Serializer

  attributes :id, :total_amount, :status, :created_at, :updated_at

  has_many :order_items, serializer: OrderItemSerializer
end
