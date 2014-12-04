require 'spec_helper'

describe "Faqs" do
  before(:all) do
    @default_faq = create(:faq, :question => "DefaultQuestion", :answer => "DefaultAnswer")
    @rank = create(:rank)
    @my_admin = create(:user, :admin => true, :level => @rank.level)
  end

  after(:all) do
    Faq.destroy(@default_faq.id)
    User.destroy(@my_admin.id)
    Rank.destroy(@rank.id)
  end


  describe "GET /faqs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get faqs_path
      response.status.should be(200)
    end

    it "should successfully load faq page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit faqs_path
      page.should have_content("FAQs")
    end
  end


  describe "NEW /faq" do
    it "should have created faq with factory girl" do
      ui_sign_in(@my_admin)
      item = create(:faq, :question => "QuestionFG", :answer => "AnswerFG")
      expect((Faq.find_by question: item.question).answer).to eq(item.answer)
      visit faqs_path
      page.should have_content(item.question)
      Faq.destroy(item.id)
      ui_sign_out
    end

    it "should have created faq via new_page" do
      ui_sign_in(@my_admin)
      item = build(:faq, :question => "QuestionNFAQ", :answer => "AnswerNFAQ")
      fill_new_form_with(item)
      expect((Faq.find_by question: item.question).answer).to eq(item.answer)
      visit faqs_path
      page.should have_content(item.question)
      Faq.destroy(Faq.find_by question: item.question)
      ui_sign_out
    end

    it "should throw error when updating with blank question" do
      ui_sign_in(@my_admin)
      item = build(:faq, :question => nil, :answer => nil)
      fill_new_form_with(item)
      page.should have_content("Question can't be empty")
      ui_sign_out
    end
  end


  describe "SHOW /faq" do
    it "should load show_faq page" do
      visit faq_path @default_faq
      page.should have_content(@default_faq.question)
      page.should have_content(@default_faq.answer)
    end
  end

  describe "EDIT /faq" do
    it "should load edit_faq page" do
      ui_sign_in(@my_admin)
      visit edit_faq_path @default_faq
      page.should have_content("Editing FAQ")
      ui_sign_out
    end

    it "should fill out valid faq and confirm" do
      ui_sign_in(@my_admin)
      item1 = create(:faq)
      visit edit_faq_path item1
      item2 = build(:faq, :question => "QuestionEFAQ", :answer => "AnswerEFAQ")
      fill_in "Question", :with => item2.question
      fill_in "Answer", :with => item2.answer
      click_button "Update"
      confirm_db_and_user_page(item2)
      Faq.destroy(item1.id)
      ui_sign_out
    end
  end


  def confirm_db_and_user_page(item)
    expect((Faq.find_by question: item.question).answer).to eq(item.answer)
    visit faqs_path
    page.should have_content(item.question)
  end

  def fill_new_form_with(item)
    visit new_faq_path
    fill_in "Question", :with => item.question
    fill_in "Answer", :with => item.answer
    click_button "Create"
  end
end
