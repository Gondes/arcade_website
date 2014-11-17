# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  #two different ways of using sequences
  sequence :user_name do |n|
    "user#{n}"
  end

  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    first_name "first"
    last_name "last"
    user_name
    email
    password "password"

    factory :zero_stat_user do
      games_played_count = 0
      wins_count = 0
      loss_count = 0
      tie_count = 0
      best_win_streak = 0
      current_win_streak = 0
      level = 1
      exp = 0
    end

    factory :sample_stat_user do
      games_played_count = 26
      wins_count = 20
      loss_count = 4
      tie_count = 2
      best_win_streak = 2
      current_win_streak = 1
      level = 3
      exp = 400
    end
  end
end
