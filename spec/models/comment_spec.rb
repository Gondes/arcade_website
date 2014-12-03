require 'spec_helper'

describe Comment do
  describe 'methods' do
    it 'commenter should return the comment user' do
      user = create(:user)
      comment = build(:comment, :user_id => user.id)
      comment.commenter.should eq(user)
      User.destroy(user.id)
    end

    it 'forum should return the general_forum_topic' do
      forum = create(:general_forum_topic)
      topic = create(:discussion_topic, :general_forum_topic_id => forum.id)
      comment = build(:comment, :discussion_topic_id => topic.id)
      comment.forum.should eq(forum)
      DiscussionTopic.destroy(topic.id)
      GeneralForumTopic.destroy(forum.id)
    end

    it 'show_content should return content if removed is false, which it is by default' do
      comment = build(:comment)
      comment.show_content.should eq(comment.content)
    end

    it 'show_content should return error message if removed is true' do
      comment = build(:comment, :removed => true)
      comment.show_content.should eq("---This comment has been removed---")
    end
  end
end
