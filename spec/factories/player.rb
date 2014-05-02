FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    event

    trait :invalid do
      name nil
    end

  end
end
