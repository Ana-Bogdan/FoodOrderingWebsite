FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:category) { |n| "Category #{n}" }
    vegetarian { [ true, false ].sample }
    price { rand(5.0..50.0).round(2) }
    image { "https://example.com/image#{rand(1..100)}.jpg" }
  end
end
