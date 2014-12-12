require 'spec_helper'

describe CommentsController do
  before(:each) do
    @my_user = create(:user)
    @my_comment = create(:comment)
  end

  after(:each) do
    User.destroy(@my_user.id)
    Comment.destroy(@my_comment.id)
  end

  describe "GET 'edit'" do
    it "users cannot edit their comments after creating it." do
      topic = create(:discussion_topic)
      comment = create(:comment, :discussion_topic_id => topic.id)
      sign_in @my_user
      get 'edit', :id => comment
      response.should_not be_success
      sign_out @my_user
      Comment.destroy(comment.id)
      DiscussionTopic.destroy(topic.id)
    end

    it "admins should be able to access comment edits." do
      my_admin = create(:user, :forum_access => true)
      sign_in my_admin
      get 'edit', :id => @my_comment
      response.should be_success
      sign_out my_admin
      User.destroy(my_admin.id)
    end
  end

  describe "new" do
    it "get new_comment should be sucess if logged in" do
      topic = create(:discussion_topic)
      sign_in @my_user
      get :new, :topic_id => topic.id
      expect(response).to be_success
      sign_out @my_user
      DiscussionTopic.destroy(topic.id)
    end

    it "get new_comment should not succeed and redirect if topic is closed" do
      topic = create(:discussion_topic, :closed => true)
      sign_in @my_user
      get :new, :topic_id => topic.id
      expect(response).to_not be_success
      response.should redirect_to discussion_topic_path(topic)
      sign_out @my_user
      DiscussionTopic.destroy(topic.id)
    end
  end

  describe "create" do
    it "POST should create new comment and redirect to specified page" do
      topic = create(:discussion_topic)
      attributes = attributes_for(:comment, :discussion_topic_id => topic.id)
      expect { post :create, :comment => attributes }.should change(Comment, :count)
      response.should redirect_to(discussion_topic_path(topic))
      DiscussionTopic.destroy(topic.id)
    end
  end

  describe "update" do
    it "PUT should update" do
      topic = create(:discussion_topic)
      comment = create(:comment, :discussion_topic_id => topic.id)
      sign_in @my_user
      attributes = {:removed => true}
      put :update, :id => comment, :comment => attributes
      comment.reload
      comment.removed.should eq(attributes[:removed])
      sign_out @my_user
      DiscussionTopic.destroy(topic.id)
    end

    it "PUT faq should not update if not signed in" do
      attributes = attributes_for(:comment, :removed => true)
      put :update, :id => @my_comment, :comment => attributes
      @my_comment.reload
      @my_comment.removed.should_not eq(attributes[:removed])
    end
  end
end
