FactoryGirl.define do
  factory :user do
    name "User Name Here"

    trait :invalid do
      name nil
    end

  end
end
