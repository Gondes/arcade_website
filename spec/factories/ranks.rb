# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rank do
    sequence(:name) { |n| "name#{n}" }
    sequence(:level, 1) { |n| n }
    sequence(:exp_required, 1) { |n| n }
  end
end
