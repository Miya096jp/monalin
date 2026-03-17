FactoryBot.define do
  factory :session do
    sequence(:session_title) { |n| "セッション#{n}" }
    association :user
  end
end
