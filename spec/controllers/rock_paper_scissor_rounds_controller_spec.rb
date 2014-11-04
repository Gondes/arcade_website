require 'spec_helper'

describe RockPaperScissorRoundsController do
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
      get :index, :game_id => @game.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end
  end
end
