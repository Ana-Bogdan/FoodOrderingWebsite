class OrderSerializer
  include Alba::Resource

  attributes :id, :total_amount, :status, :created_at, :updated_at

  many :order_items, resource: OrderItemSerializer
end
