FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    event

    trait :invalid do
      name nil
    end

  end
end
