class CartItemSerializer
  include JSONAPI::Serializer

  attributes :id, :quantity

  attribute :total_price do |cart_item|
    cart_item.quantity * cart_item.product.price
  end

  belongs_to :product, serializer: ProductSerializer
end
