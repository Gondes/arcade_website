require 'spec_helper'

describe UsersController do
  before(:each) do
    @my_user = create(:user)
  end

  after(:each) do
    delete :destroy, :id => @my_user
  end

  describe "index" do
    it "GET index" do
      get :index
      expect(response).to be_success
      response.status.should be(200)
    end
  end

  describe "show" do
    it "GET show_user" do
      sign_in @my_user
      
      get :show, :id => @my_user
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end

    it "if not logged in, it should redirect to users_path" do
      get :show, :id => @my_user.id
      response.should redirect_to users_path
    end
  end

  #describe "new" do
    #Technically, the new_user has been combined with the sign_up page so this is not needed
  #end

   describe "edit" do
    it "GET edit_user" do
      sign_in @my_user
      get :edit, :id => @my_user.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end

    it "if not logged in, it should redirect to users_path", type: :request do
      get :edit, :id => @my_user.id
      response.should redirect_to users_path
    end
  end

  describe "destroy" do
    it "DELETE user" do
      account = create(:user, :user_name => "Fire", :email => "ricky.flame@example.com")
      expect((User.find account.id).user_name).should eq(account.user_name)
      delete :destroy, :id => account
      lambda { User.find account.id }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "update" do
    it "PUT user" do
      attributes = attributes_for(:user, :user_name => "un", :first_name => "fn", :last_name => "ln")
      put :update, :id => @my_user, :user => attributes
      @my_user.reload
      @my_user.user_name.should eq(attributes[:user_name])
      @my_user.first_name.should eq(attributes[:first_name])
      @my_user.last_name.should eq(attributes[:last_name])
    end

    pending "Still wondering how to check validation for backend update for #{__FILE__}"
  end

  describe "reset_stats" do
    it "should reset user's stats and save" do
      account = create(:user, :user_name => "Fire", :email => "ricky.flame@example.com", :games_played_count => 1)
      put :reset_stats, :id => account
      account.reload
      account.games_played_count.should eq(0)
      delete :destroy, :id => account
      # I am assuming that testing one column should be sufficient to prove this action works
      #put :reset_stats, :id => @my_user
      #expect(response).to be_success
      #response.status.should be(200)
    end
  end
end
