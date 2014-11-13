require 'spec_helper'

describe RanksController do

  before(:each) do
    @rank = create(:rank)
  end

  after(:each) do
    Rank.destroy(@rank.id)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should navigate to edit page if user is admin" do
      my_user = create(:user, :admin => true)
      sign_in my_user
      get :edit, :id => @rank
      response.should be_success
      User.destroy(my_user)
      sign_out my_user
    end
  end

  describe "GET 'edit'" do
    it "should redirect to index if user is not admin" do
      get :edit, :id => @rank
      response.should_not be_success
    end
  end

  describe "Put 'update'" do
    it "should return success" do
      attributes = attributes_for(:rank, :level =>  1001)
      put :update, :id => @rank, :rank => attributes
      @rank.reload
      @rank.level.should eq(attributes[:level])
    end

    it "should not update" do
      rank = create(:rank)
      attributes = attributes_for(:rank, :level => rank.level)
      put :update, :id => @rank, :rank => attributes
      @rank.reload
      @rank.level.should_not eq(attributes[:level])
      Rank.destroy(rank.id)
    end
  end

end
