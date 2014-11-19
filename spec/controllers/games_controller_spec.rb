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
      game = create(:game, :done => true, :user_1_id => @my_user.id,
                    :user_2_id => @my_enemy.id)
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

  describe "create" do
    it "POST should create new game" do
      sign_in @my_user
      attributes = attributes_for(:game, :round_count => 3,
        :user_1_id => @my_user.id, :user_2_id => @my_enemy.id)
      expect { post :create, :game => attributes }.should change(Game, :count)
      Game.destroy(Game.order("created_at").last)
      sign_out @my_user
    end

    it "POST should not create new game" do
      sign_in @my_user
      attributes = attributes_for(:game, :user_1_id => nil, :user_2_id => nil)
      expect { post :create, :game => attributes }.should_not change(Game, :count)
      sign_out @my_user
    end
  end

  describe "update" do
    it "should update the stats of the game" do
      sign_in @my_user
      @game.user_1_win_count.should eq(0)
      attributes = attributes_for(:game, :user_1_win_count => 1)
      put :update, :id => @game, :game => attributes
      @game.reload
      @game.user_1_win_count.should eq(attributes[:user_1_win_count])
      sign_out @my_user
    end

    it "should not update the stats of the game" do
      sign_in @my_user
      attributes = attributes_for(:game, :user_1_id => nil)
      put :update, :id => @game, :game => attributes
      @game.reload
      @game.user_1_id.should_not eq(attributes[:user_1_id])
      sign_out @my_user
    end
  end

  describe "destroy" do
    it "DELETE game" do
      sign_in @my_user
      game = create(:game, :user_1_id => @my_user.id, :user_2_id => @my_enemy.id)
      game.reload
      expect((Game.find game.id).user_1_id).should eq(game.user_1_id)
      expect { delete :destroy, :id => game.id }.should change(Game, :count)
      lambda { Game.find game.id }.should raise_error(ActiveRecord::RecordNotFound)
      sign_out @my_user
    end
  end

  describe "accept" do
    it "should transfer the challenge fee to " do
      user_1 = create(:user, :level => 1)
      user_2 = create(:user, :level => 2)
      sign_in user_2
      game = create(:game, :user_1_id => user_1.id, :user_2_id => user_2.id,
                    :fee => 10)
      put :accept, :id => game.id
      game.reload
      game.accepted.should eq(true)
      game.player_1.coins.should eq(0)
      game.player_2.coins.should eq(10)
      User.destroy(user_1.id)
      User.destroy(user_2.id)
      Game.destroy(game.id)
      sign_out user_2
    end
  end

  describe "reject" do
    it "should refund fee and destroy games" do
      user_1 = create(:user, :level => 1)
      user_2 = create(:user, :level => 2)
      sign_in user_2
      game = create(:game, :user_1_id => user_1.id, :user_2_id => user_2.id,
                    :fee => 10)
      expect { put :reject, :id => game.id }.should change(Game, :count)
      user_1.reload
      user_1.coins.should eq(10)
      User.destroy(user_1.id)
      User.destroy(user_2.id)
      sign_out user_2
    end
  end
end
