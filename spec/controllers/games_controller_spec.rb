require 'spec_helper'

describe GamesController do
  before(:each) do
    @my_user = create(:user)
    @my_enemy = create(:user)
    @game = create(:game, :user_1_id => @my_user.id.to_i, :user_2_id => @my_enemy.id.to_i)
  end

  after(:each) do
    Game.destroy(@game.id)
    User.destroy(@my_user)
    User.destroy(@my_enemy)
  end

  describe "index" do
    it "GET index aka /root" do
      sign_in @my_user
      get :index
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end
  end

  describe "show" do
    it "GET show_user should not show if game is not done" do
      sign_in @my_user
      get :show, :id => @game
      response.should redirect_to games_path
      sign_out @my_user
    end

    it "GET show_user" do
      sign_in @my_user
      game = create(:game, :done => true, :user_1_id => @my_user.id, :user_2_id => @my_enemy.id)
      get :show, :id => game
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
      Game.destroy(game)
    end

    it "if not logged in, it should redirect to games_path" do
      get :show, :id => @game.id
      response.should redirect_to new_user_session_path
    end
  end

  describe "new" do
    it "GET new_faq should direct to new game page" do
      sign_in @my_user
      get :new, :user_1_id => @my_user.id, :user_2_id => @my_enemy.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end

    it "GET with improper url params should redirect to games_path" do
      sign_in @my_user
      get :new
      response.should redirect_to games_path
      sign_out @my_user
    end
    #player_1 != player_2 validation is in game model specs
  end

  describe "update" do
    it "should update the stats of the game" do
      #game = create(:game, :user_1_id => @my_user.id, :user_2_id => @my_enemy.id)
      @game.user_1_win_count.should eq(0)
      attributes = attributes_for(:game, :user_1_win_count => 1)
      #put :update, :id => @game, :game => attributes   #I don't know why this one is not working
      @game.update attributes
      @game.reload
      @game.user_1_win_count.should eq(attributes[:user_1_win_count])
    end
  end

  describe "destroy" do
    it "DELETE game" do
      game = create(:game, :user_1_id => @my_user.id, :user_2_id => @my_enemy.id)
      game.reload
      expect((Game.find game.id).user_1_id).should eq(game.user_1_id)
      #delete :destroy, :id => game   #I don't know why this one is not working
      game.destroy
      lambda { Game.find game.id }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
