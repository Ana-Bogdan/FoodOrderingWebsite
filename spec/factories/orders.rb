FactoryBot.define do
  factory :order do
    user
    total_amount { rand(10.0..100.0).round(2) }
    status { "pending" }

    trait :completed do
      status { "completed" }
    end

    trait :cancelled do
      status { "cancelled" }
    end

    trait :with_items do
      after(:create) do |order|
        create_list(:order_item, rand(1..3), order: order)
      end
    end
  end
end
