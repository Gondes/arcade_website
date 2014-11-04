# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  # For now, you must create 2 users and pass their id's if you want to test functionality
  #with the this game factory.
  factory :game do
    name "rock_paper_scissor"
    #user_1_id 10001
    #user_2_id 10002

    # user_with_posts will create post data after the user has been created
    factory :game_with_rock_paper_scissor_rounds do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        fg_rounds_count 3
      end

      #create_list(:rock_paper_scissor_round, rounds_count, game: game)
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |game, evaluator|
        create_list(:rock_paper_scissor_round, evaluator.fg_rounds_count, game: game)
      end
    end
  end
end
