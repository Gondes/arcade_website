require 'spec_helper'

describe UsersController do
  #before(:all) do
  #  @my_user = create(:user)
  #end

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

  describe "new" do
    #Technically, the new_user has been combined with the sign_up page so this is not needed
    #it "GET user" do
    #  get :new
    #  expect(response).to be_success
    #  response.status.should be(200)
    #end

    #it "should raise validation error for question's presence" do
    #  my_user = build(:user, :question => nil, :answer => "a_update")
    #  my_user.should_not be_valid
    #end
  end

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
      @account = create(:user, :user_name => "Fire", :email => "ricky.flame@example.com")
      expect((User.find @account.id).user_name).should eq(@account.user_name)
      delete :destroy, :id => @account
      lambda { User.find @account.id }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
