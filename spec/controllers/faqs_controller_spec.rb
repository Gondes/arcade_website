require 'spec_helper'

describe FaqsController do
  before(:each) do
    @item = create(:faq)
  end

  after(:each) do
    delete :destroy, :id => @item
  end

  describe "index" do
    it "GET index aka /root" do
      get :index
      expect(response).to be_success
      response.status.should be(200)
    end
  end

  describe "show" do
    it "GET show_faq" do
      get :show, :id => @item.id
      expect(response).to be_success
      response.status.should be(200)
    end
  end

  describe "new" do
    it "GET new_faq" do
      get :new
      expect(response).to be_success
      response.status.should be(200)
    end

    it "should raise validation error for question's presence" do
      item = build(:faq, :question => nil, :answer => "a_update")
      item.should_not be_valid
    end
  end

  describe "edit" do
    it "GET edit_faq" do
      get :edit, :id => @item.id
      expect(response).to be_success
      response.status.should be(200)
    end
  end

  describe "create" do
    it "POST a new faq" do
      attributes = attributes_for(:faq, :question => "Blah?", :answer => "Blah.")
      expect { post :create, :faq => attributes }.should change(Faq, :count)
      Faq.destroy(Faq.order("created_at").last)
    end

    it "POST should fail to create a new faq" do
      attributes = attributes_for(:faq, :question => "", :answer => "Blah.")
      expect { post :create, :faq => attributes }.should_not change(Faq, :count)
    end
  end

  describe "destroy" do
    it "DELETE faq" do
      item = create(:faq)
      expect((Faq.find item.id).question).should eq(item.question)
      expect { delete :destroy, :id => item }.should change(Faq, :count)
      lambda { Faq.find item.id }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "update" do
    it "PUT faq" do
      attributes = attributes_for(:faq, :question => "q_update", :answer => "a_update")
      put :update, :id => @item, :faq => attributes
      @item.reload
      @item.answer.should eq(attributes[:answer])
      @item.question.should eq(attributes[:question])
    end

    it "PUT faq" do
      attributes = attributes_for(:faq, :question => "", :answer => "a_update")
      put :update, :id => @item, :faq => attributes
      @item.reload
      @item.answer.should_not eq(attributes[:answer])
      @item.question.should_not eq(attributes[:question])
    end
    
    pending "Still wondering how to check validation for backend update for #{__FILE__}"
  end
end
