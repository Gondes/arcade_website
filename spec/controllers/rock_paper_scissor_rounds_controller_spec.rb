require 'spec_helper'

describe RockPaperScissorRoundsController do
  before(:each) do
    @my_user = create(:user)
    @my_enemy = create(:user)
    @game = create(:game, :user_1_id => @my_user.id.to_i, :user_2_id => @my_enemy.id.to_i)
    @rps = create(:rock_paper_scissor_round, :game => @game)
  end

  after(:each) do
    Game.destroy(@game.id)
    User.destroy(@my_user)
    User.destroy(@my_enemy)
  end

  describe "authentication" do
    it "authenticate_player without game_id param" do
      sign_in @my_user
      get :show, :id => @rps.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end

    it "authenticate_player with game_id param" do
      sign_in @my_user
      get :show, :id => @rps.id, :game_id => @game.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end

    it "authenticate_player should redirect other_user" do
      other_user = create(:user)
      sign_in other_user
      get :show, :id => @rps.id, :game_id => @game.id
      response.should redirect_to games_path
      sign_out other_user
      User.destroy(other_user.id)
    end
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

  describe "show" do
    it "GET the round and show it" do
      sign_in @my_user
      get :show, :id => @rps.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end
  end

  describe "edit" do
    it "GET the round and edit it" do
      sign_in @my_user
      get :edit, :id => @rps.id
      expect(response).to be_success
      response.status.should be(200)
      sign_out @my_user
    end
  end

  describe "create" do
    it "POST new round" do
      sign_in @my_user
      attributes = attributes_for(:rock_paper_scissor_round,
        :game_id => @game.id)
      #attributes = {:round_number => 1, :game_id => @game.id}
      my_i = RockPaperScissorRound.count
      expect { post :create, :rock_paper_scissor_round => attributes, :game_id => @game.id }.should change(RockPaperScissorRound, :count)
      RockPaperScissorRound.count.should_not eq(my_i)
      sign_out @my_user
    end
  
    it "POST should not create new round" do
      attributes = attributes_for(:rock_paper_scissor_round, :game_id => nil)
      my_i = RockPaperScissorRound.count
      post :create, :rock_paper_scissor_round => attributes, :game_id => @game.id
      RockPaperScissorRound.count.should eq(my_i)
    end
  end

  describe "update" do
    it "PUT should update this completed round and find winner" do
      rank = create(:rank, :level => 1, :exp_required => 0)
      sign_in @my_user
      attributes = attributes_for(:rock_paper_scissor_round, :user_1_move => "paper",
                                  :user_2_move => "paper")
      @rps.user_1_move.should_not eq(attributes[:user_1_move])
      put :update, :id => @rps.id, :rock_paper_scissor_round => attributes
      @rps.reload
      @rps.user_1_move.should eq(attributes[:user_1_move])
      RockPaperScissorRound.destroy(@rps.id)
      sign_out @my_user
      Rank.destroy(rank.id)
    end

    it "PUT should update, but not find a winner" do
      sign_in @my_user
      attributes = attributes_for(:rock_paper_scissor_round, :user_1_move => "paper")
      @rps.user_1_move.should_not eq(attributes[:user_1_move])
      put :update, :id => @rps.id, :rock_paper_scissor_round => attributes
      @rps.reload
      @rps.user_1_move.should eq(attributes[:user_1_move])
      RockPaperScissorRound.destroy(@rps.id)
      sign_out @my_user
    end

    it "PUT should not update finished round" do
      sign_in @my_user
      rps = create(:rock_paper_scissor_round, :game => @game, :user_1_move => "paper",
                     :user_2_move => "paper")
      attributes = attributes_for(:rock_paper_scissor_round, :user_1_move => "scissor")
      rps.user_1_move.should_not eq(attributes[:user_1_move])
      put :update, :id => rps.id, :rock_paper_scissor_round => attributes
      rps.reload
      rps.user_1_move.should_not eq(attributes[:user_1_move])
      RockPaperScissorRound.destroy(rps.id)
      sign_out @my_user
    end
  end

  describe "destroy" do
    it "DELETE round" do
      sign_in @my_user
      rps = create(:rock_paper_scissor_round, :game => @game)
      expect { delete :destroy, :id => rps }.should change(RockPaperScissorRound, :count)
      lambda { RockPaperScissorRound.find rps.id }.should raise_error(ActiveRecord::RecordNotFound)
      sign_out @my_user
    end
  end
end
