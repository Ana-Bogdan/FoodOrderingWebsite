class AdminOrderSerializer
  include JSONAPI::Serializer

  attributes :total_amount, :status, :created_at

  def self.record_type
    "order"
  end

  attribute :user_info do |order|
    {
      name: order.user.name,
      email: order.user.email
    }
  end

  attribute :order_items_info do |order|
    order.order_items.map do |item|
      {
        quantity: item.quantity,
        price_at_time: item.price_at_time,
        product: {
          name: item.product.name,
          category: item.product.category,
          vegetarian: item.product.vegetarian
        }
      }
    end
  end
end
