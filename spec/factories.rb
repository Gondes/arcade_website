FactoryGirl.define do
  sequence :title do |n|
    "topic title#{n}"
  end

  factory :faq do
    question "Some title"
    answer "Some answer."
  end

  factory :comment do
    content 'Some content'
    discussion_topic_id 0
    user_id 1
  end

  factory :discussion_topic do
    title
    description 'discussion topic description'
    general_forum_topic_id = 0
    user_id = 1
  end

  factory :general_forum_topic do
    title
    description 'general forum topic description'
  end
end