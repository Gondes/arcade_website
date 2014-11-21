FactoryGirl.define do

  factory :comment do
    content "MyText"
    discussion_topic_id 1
    user_id 1
    removed false
  end

  factory :discussion_topic do
    title "MyString"
    description "MyText"
    general_forum_topic_id 1
    creator_id 1
    closed false
    removed false
  end

  factory :general_forum_topic do
    title "MyString"
	description "MyText"
  end

  factory :faq do
    question "Some title"
    answer "Some answer."
  end
end