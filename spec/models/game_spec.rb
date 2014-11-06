require 'spec_helper'

describe Game do
  before(:all) do
    @d_user1 = create(:user)
    @d_user2 = create(:user)
  end

  after(:all) do
    User.destroy(d_user1.id)
    User.destroy(d_user2.id)
  end

  describe "test" do
    it "using factories with associations" do
      g1 = build(:game, :user_1_id => 10001, :user_2_id => 10002)
      g1.user_1_id.should eq(10001)
      g1.user_2_id.should eq(10002)
    end

    it "passing in users" do
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user2.id)
      g1.user_1_id.should eq(@d_user1.id)
      g1.user_2_id.should eq(@d_user2.id)
    end

    it "should create 3 rounds" do
      g1 = create(:game_with_rock_paper_scissor_rounds,
        :user_1_id => @d_user1.id, :user_2_id => @d_user2.id)
      g1.reload
      g1.rock_paper_scissor_rounds.count.should eq(3)
      Game.destroy(g1.id)
    end

    it "should create specified amount of rounds" do
      g1 = create(:game_with_rock_paper_scissor_rounds, :fg_rounds_count => 1,
        :user_1_id => @d_user1.id, :user_2_id => @d_user2.id)
      g1.reload
      g1.rock_paper_scissor_rounds.count.should eq(1)
      Game.destroy(g1.id)
    end
  end


  describe "methods" do
    it "player_1 and player_2 methods" do
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user2.id)
      g1.player_1.name.should eq(@d_user1.user_name)
      g1.player_2.name.should eq(@d_user2.user_name)
    end

    it "winner should return winner only if not nil" do
      g1 = build(:game, :winner_id => @d_user1.id)
      g1.winner.name.should eq(@d_user1.name)
    end

    it "clean_name should capitalize words and remove '_''s " do
      g1 = build(:game, :name => "rock_paper_scissor")
      g1.clean_name.should eq("Rock Paper Scissor")
    end

    it "finished? should be finished if round_count == user_1_win_count + user_2_win_count + tie_count" do
      g1 = build(:game, :round_count => 3)
      g1.finished?.should eq(false)
      g1 = build(:game, :round_count => 3, :user_1_win_count => 1, :tie_count => 2)
      g1.finished?.should eq(true)
    end

    it "try_to_generate_winner assuming game.winner works" do
      user1 = create(:user)
      user2 = create(:user)
      g1 = build(:game, :user_1_id => user1.id, :user_2_id => user2.id,
        :round_count => 3, :user_1_win_count => 1, :tie_count => 2)
      g1.try_to_generate_winner
      g1.winner.name.should eq(user1.name)
      User.destroy(user1.id)
      User.destroy(user2.id)
    end

    it "try_to_generate_winner assuming game.winner works" do
      user1 = create(:user)
      user2 = create(:user)
      g1 = build(:game, :user_1_id => user1.id, :user_2_id => user2.id,
        :round_count => 3, :tie_count => 3)
        #:round_count => 2, :user_1_win_count => 1, :user_2_win_count => 1)
      g1.try_to_generate_winner
      g1.winner.should eq(nil)
      User.destroy(user1.id)
      User.destroy(user2.id)
    end
  end
  

  describe "validation" do
    it "player_1_id should not equal player_2_id" do
      user1 = create(:user, :id => 1)
      g1 = build(:game, :user_1_id => user1.id, :user_2_id => user1.id)
      g1.should_not be_valid
      User.destroy(user1.id)
    end

    pending "write better validation for presence of player_1 and 2 ids in #{__FILE__}"
    #it "player_1_id and player_2_id should not be nil" do
    #  g1 = build(:game, :user_1_id => nil, :user_2_id => nil)
    #  g1.should_not be_valid
    #end
  end
end
