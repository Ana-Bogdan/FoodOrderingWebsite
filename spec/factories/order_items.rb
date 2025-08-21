FactoryBot.define do
  factory :order_item do
    order
    product
    quantity { rand(1..5) }
    price_at_time { rand(5.0..50.0).round(2) }
  end
end
