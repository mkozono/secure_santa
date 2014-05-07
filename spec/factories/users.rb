# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Alexandre Dumas"
    provider :facebook
    uid 123
  end
end
