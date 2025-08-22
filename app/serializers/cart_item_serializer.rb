class CartItemSerializer
  include Alba::Resource

  attributes :id, :quantity

  attribute :total_price do |cart_item|
    cart_item.quantity * cart_item.product.price
  end

  one :product, resource: ProductSerializer
end
