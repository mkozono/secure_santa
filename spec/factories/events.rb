FactoryGirl.define do
  factory :event do
    name "Event Name Here"

    trait :invalid do
      name nil
    end
    
  end
end
