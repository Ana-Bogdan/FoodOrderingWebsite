class AdminOrderSerializer
  include Alba::Resource

  attributes :id, :total_amount, :status, :created_at, :updated_at

  attribute :user_info do |order|
    {
      name: order.user.name,
      email: order.user.email,
      role: order.user.role
    }
  end

  many :order_items, resource: OrderItemSerializer
end
