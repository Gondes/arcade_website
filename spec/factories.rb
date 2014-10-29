FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    user_name "Deer"
    email { "#{first_name}.#{last_name}@example.com".downcase }
    password "password"
  end

  factory :faq do
    question "Some title"
    answer "Some answer."
  end
end