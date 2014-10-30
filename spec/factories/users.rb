# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    user_name "Deer"
    email { "#{first_name}.#{last_name}@example.com".downcase }
    password "password1"
  end

  factory :user_empty do
    first_name ""
    last_name ""
    user_name ""
    email { "" }
    password ""
  end
end
