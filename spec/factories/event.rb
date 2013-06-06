FactoryGirl.define do
  factory :event do
    name { Faker::Company.catch_phrase }

    factory :event_with_users do
      ignore { users_count 5 }
      after(:create) do |event, evaluator|
        FactoryGirl.create_list(:user, evaluator.users_count, event: event)
      end
    end

    trait :invalid do
      name nil
    end
    
  end
end
