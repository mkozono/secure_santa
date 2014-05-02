FactoryGirl.define do
  factory :event do
    name { Faker::Company.catch_phrase }

    factory :event_with_players do
      ignore { players_count 3 }
      after(:create) do |event, evaluator|
        FactoryGirl.create_list(:player, evaluator.players_count, event: event)
      end
    end

    trait :invalid do
      name nil
    end

  end
end
