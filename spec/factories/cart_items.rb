FactoryBot.define do
  factory :cart_item do
    cart
    product
    quantity { rand(1..5) }
  end
end
