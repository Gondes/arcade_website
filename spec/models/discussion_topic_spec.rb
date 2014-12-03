require 'spec_helper'

describe DiscussionTopic do
  describe 'methods' do
    it 'original_poster should return the original poster user' do
      user = create(:user)
      topic = build(:discussion_topic, :user_id => user.id)
      topic.original_poster.should eq(user)
      User.destroy(user.id)
    end

    it 'closed_status should return "Open" when closed is false, which it should be by default' do
      topic = build(:discussion_topic)
      topic.closed_status.should eq("Open")
    end

    it 'closed_status should return "Closed" when closed is true' do
      topic = build(:discussion_topic, :closed => true)
      topic.closed_status.should eq("Closed")
    end

    it 'comments_count should be 0' do
      topic = create(:discussion_topic)
      topic.comments_count.should eq(0)
      DiscussionTopic.destroy(topic.id)
    end

    it 'comments_count should be 1' do
      topic = create(:discussion_topic)
      comment = create(:comment, :discussion_topic_id => topic.id)
      topic.comments_count.should eq(1)
      Comment.destroy(comment.id)
      DiscussionTopic.destroy(topic.id)
    end

    it 'is_op? should return true if some_id is equal to original_poster' do
      topic = build(:discussion_topic, :user_id => 1)
      (topic.is_op?(1)).should eq(true)
    end

    it 'is_op? should return false if some_id is not equal to original_poster' do
      topic = build(:discussion_topic, :user_id => 1)
      (topic.is_op?(2)).should eq(false)
    end

    it 'exist? should return true if the title and description are not nil' do
      topic = build(:discussion_topic)
      topic.exist?.should eq(true)
    end

     it 'exist? should return false if the title and description are nil' do
      topic = build(:discussion_topic, :title => nil, :description => nil)
      topic.exist?.should eq(false)
    end
  end
end
