require 'spec_helper'

describe GeneralForumTopic do
  describe 'methods' do
    it 'name should return the title capitalized with spaces' do
      forum = build(:general_forum_topic, :title => 'some title')
      forum.name.should eq('Some Title')
    end

    it 'discussion_topics_count should be 0' do
      forum = create(:general_forum_topic)
      forum.discussion_topics_count.should eq(0)
      GeneralForumTopic.destroy(forum.id)
    end

    it 'discussion_topics_count should be 1' do
      forum = create(:general_forum_topic)
      topic = create(:discussion_topic, :general_forum_topic_id => forum.id)
      forum.discussion_topics_count.should eq(1)
      DiscussionTopic.destroy(topic.id)
      GeneralForumTopic.destroy(forum.id)
    end
  end
end
