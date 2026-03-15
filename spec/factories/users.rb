FactoryBot.define do
  factory :user do
    username { "testuser" }
    sequence(:email) { |n| "test#{n}@example.com" }
    role { :user }
    status { :active }
    tickets { 3 }
    stripe_customer_id { nil }
  end
end
