FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "user" }

    trait :admin do
      role { "admin" }
    end

    trait :with_cart do
      after(:create) do |user|
        create(:cart, user: user)
      end
    end
  end
end
