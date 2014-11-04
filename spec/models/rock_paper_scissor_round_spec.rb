require 'spec_helper'

describe RockPaperScissorRound do
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

  describe "test" do
    it "create using factories with associations" do
      rps = create(:rock_paper_scissor_round, :game_id => @game.id)
      rps.reload
      expect(RockPaperScissorRound.find rps.id).should_not be(nil)
      RockPaperScissorRound.destroy(rps.id)
    end
  end

  describe "methods" do
    it "game should return the game associated to the round" do
      rps = build(:rock_paper_scissor_round, :game_id => @game.id)
      rps.game.should eq(@game)
    end

    it "winner should return nil when winner_id is nil" do
      rps = build_stubbed(:rock_paper_scissor_round)
      rps.winner_id.should be(nil)
      rps.winner.should eq(nil)
    end

    it "winner should return winner when it exists" do
      rps = build_stubbed(:rock_paper_scissor_round, :winner_id => @my_user.id)
      rps.winner_id.should_not be(nil)
      rps.winner.should eq(@my_user)
    end

    it "finished? should return false if user_1_move or user_2_move is nil" do
      rps = build_stubbed(:rock_paper_scissor_round)
      rps.finished?.should be(false)
      rps = build_stubbed(:rock_paper_scissor_round, :user_1_move => "rock")
      rps.finished?.should be(false)
      rps = build_stubbed(:rock_paper_scissor_round, :user_2_move => "paper")
      rps.finished?.should be(false)
    end

    it "finished? should return true if both user_moves exist" do
      rps = build_stubbed(:rock_paper_scissor_round,
                          :user_1_move => "rock", :user_2_move => "paper")
      rps.finished?.should be(true)
    end

    it "is_locked? should return false if round number is 1" do
      # The first round of any game should not be locked
      rps = build_stubbed(:rock_paper_scissor_round)
      rps.is_locked?.should be(false)
    end

    it "is_locked? should return false if previous round is complete" do
      rps1 = create(:rock_paper_scissor_round, :game => @game,
                           :user_1_move => "rock", :user_2_move => "paper")
      rps2 = build_stubbed(:rock_paper_scissor_round, :game => @game,
                           :round_number => 2)
      rps2.is_locked?.should be(false)
      RockPaperScissorRound.destroy(rps1.id)
    end

    it "is_locked? should return true if previous round is not complete" do
      rps1 = create(:rock_paper_scissor_round, :game => @game,
                           :user_1_move => nil, :user_2_move => nil)
      rps2 = build_stubbed(:rock_paper_scissor_round, :game => @game,
                           :round_number => 2)
      rps2.is_locked?.should be(true)
      RockPaperScissorRound.destroy(rps1.id)
    end

    it "get_move_value should return 1, 2, 3, 0 for rock, paper, scissor, empty" do
      rps = build_stubbed(:rock_paper_scissor_round)
      rps.get_move_value("rock").should eq(1)
      rps.get_move_value("paper").should eq(2)
      rps.get_move_value("scissor").should eq(3)
      rps.get_move_value("").should eq(0)
    end

    it "get_move_value should return 1, 2, 3, 0 for rock, paper, scissor, empty" do
      rps = build_stubbed(:rock_paper_scissor_round)
      rps.get_move_value("rock").should eq(1)
      rps.get_move_value("paper").should eq(2)
      rps.get_move_value("scissor").should eq(3)
      rps.get_move_value("").should eq(0)
    end

    it "user_1_move_id should return 1, 2, 3, 0 for depending on user_1_move" do
      rps = build_stubbed(:rock_paper_scissor_round, :user_1_move => "rock")
      rps.user_1_move_id.should eq(1)
      rps = build_stubbed(:rock_paper_scissor_round, :user_1_move => "paper")
      rps.user_1_move_id.should eq(2)
      rps = build_stubbed(:rock_paper_scissor_round, :user_1_move => "scissor")
      rps.user_1_move_id.should eq(3)
    end

    it "user_2_move_id should return 1, 2, 3, 0 for depending on user_2_move" do
      rps = build_stubbed(:rock_paper_scissor_round, :user_2_move => "rock")
      rps.user_2_move_id.should eq(1)
      rps = build_stubbed(:rock_paper_scissor_round, :user_2_move => "paper")
      rps.user_2_move_id.should eq(2)
      rps = build_stubbed(:rock_paper_scissor_round, :user_2_move => "scissor")
      rps.user_2_move_id.should eq(3)
    end

    it "find_winner should update counts" do
      rps = build(:rock_paper_scissor_round, :game => @game,
                  :user_1_move => "rock", :user_2_move => "paper")
      rps.game.user_2_win_count.should eq(0)
      rps.find_winner.should eq(nil)
      rps.game.user_2_win_count.should eq(1)
    end

    it "find_winner should update winner for game" do
      game = create(:game_with_rock_paper_scissor_rounds, :user_1_id => @my_user.id,
                    :user_2_id => @my_enemy.id, :fg_rounds_count => 1, :round_count => 1)
      rps = create(:rock_paper_scissor_round, :game => game,
                  :user_1_move => "rock", :user_2_move => "paper")
      rps.find_winner
      rps.game.winner_id.should eq(game.user_2_id)
      Game.destroy(game.id)
    end
  end
end
