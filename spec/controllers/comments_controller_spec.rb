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

  describe "GET 'index" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      sign_in @my_user
      get 'edit', :id => @my_comment
      response.should be_success
      sign_out @my_user
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
      sign_in @my_user
      attributes = attributes_for(:comment, :removed => true)
      put :update, :id => @my_comment, :comment => attributes
      @my_comment.reload
      @my_comment.removed.should eq(attributes[:removed])
      sign_out @my_user
    end

    it "PUT faq should not update if not signed in" do
      attributes = attributes_for(:comment, :removed => true)
      put :update, :id => @my_comment, :comment => attributes
      @my_comment.reload
      @my_comment.removed.should_not eq(attributes[:removed])
    end
  end
end
