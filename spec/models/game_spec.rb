require 'spec_helper'

describe Game do
  before(:all) do
    @d_user1 = create(:user)
    @d_user2 = create(:user)
  end

  after(:all) do
    User.destroy(@d_user1.id)
    User.destroy(@d_user2.id)
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

    it "winner.name should return user 1.name" do
      #g1 = build(:game, :winner_id => @d_user1.id)
      g1 = build(:game, :user_1_id => @d_user1.id, :round_count => 1,
                 :user_1_win_count => 1)
      g1.winner.name.should eq(@d_user1.name)
    end

    it "winner.name should return user_2.name" do
      #g1 = build(:game, :winner_id => @d_user1.id)
      g1 = build(:game, :user_2_id => @d_user2.id, :round_count => 1,
                 :user_2_win_count => 1)
      g1.winner.name.should eq(@d_user2.name)
    end

    it "winner should return nil when tie" do
      #g1 = build(:game, :winner_id => @d_user1.id)
      g1 = build(:game, :round_count => 1, :tie_count => 1)
      g1.winner.should eq('tie')
    end

    it "winner should return nil when not finished" do
      #g1 = build(:game, :winner_id => @d_user1.id)
      g1 = build(:game, :round_count => 1)
      g1.winner.should eq(nil)
    end

    it "winner_status should return user_2.name" do
      g1 = build(:game, :user_2_id => @d_user2.id, :round_count => 1,
                 :user_2_win_count => 1)
      g1.winner_status.should eq(@d_user2.name)
    end

    it "winner_status should return nil when tie" do
      g1 = build(:game, :round_count => 1, :tie_count => 1)
      g1.winner_status.should eq('Tie!')
    end

    it "winner_status should return nil when not finished" do
      g1 = build(:game, :round_count => 1)
      g1.winner_status.should eq(nil)
    end

    it "winner_declaration should return user 1 win declaration" do
      g1 = build(:game, :user_1_id => @d_user1.id, :round_count => 1,
                 :user_1_win_count => 1)
      g1.winner_declaration.should eq(@d_user1.name + " wins this game!")
    end

    it "winner_declaration should return a tie declaration when tie" do
      g1 = build(:game, :round_count => 1, :tie_count => 1)
      g1.winner_declaration.should eq("It's a Tie!")
    end

    it "winner_declaration should return nil when not finished" do
      g1 = build(:game, :round_count => 1)
      g1.winner_declaration.should eq(nil)
    end

    it "clean_name should capitalize words and remove '_''s " do
      g1 = build(:game, :name => "rock_paper_scissor")
      g1.clean_name.should eq("Rock Paper Scissor")
    end

    # This is subject to change until we finalize a time format
    it "end_date should return month-day-year_hour:minute if done" do
      g1 = build(:game, :done => true, :updated_at => Time.now)
      g1.end_date.should eq(g1.updated_at.strftime("%B %d, %Y, %H:%M %Z"))
    end

    it "end_date should return 'In Progress' if game is not done" do
      g1 = build(:game, :done => false)
      g1.end_date.should eq('In Progress')
    end

    it "finished? should be finished if round_count == user_1_win_count + user_2_win_count + tie_count" do
      g1 = build(:game, :round_count => 3)
      g1.finished?.should eq(false)
      g1 = build(:game, :round_count => 3, :user_1_win_count => 1, :tie_count => 2)
      g1.finished?.should eq(true)
    end

    it "try_to_generate_winner should say user 1 wins assuming game.winner works" do
      rank = create(:rank, :level => 1, :exp_required => 0)
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user2.id,
        :round_count => 3, :user_1_win_count => 1, :tie_count => 2)
      g1.try_to_generate_winner
      g1.winner.name.should eq(@d_user1.name)
      Rank.destroy(rank.id)
    end

    it "try_to_generate_winner should properly update game stats with a win" do
      rank = create(:rank, :level => 1, :exp_required => 0)
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user2.id,
        :round_count => 3, :user_1_win_count => 1, :tie_count => 2,
        :user_1_level => 1, :user_2_level => 1)
      g1.try_to_generate_winner
      g1.reload
      g1.user_1_exp_change.should eq(@d_user1.level * 10)
      g1.user_1_coins_earned.should eq(@d_user1.level * 10)
      g1.user_2_exp_change.should eq(0)
      g1.user_2_coins_earned.should eq(0)
      Rank.destroy(rank.id)
    end

    it "try_to_generate_winner should say user 2 wins assuming game.winner works" do
      rank = create(:rank, :level => 1, :exp_required => 0)
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user2.id,
        :round_count => 3, :user_2_win_count => 1, :tie_count => 2)
      g1.try_to_generate_winner
      g1.winner.name.should eq(@d_user2.name)
      Rank.destroy(rank.id)
    end

    it "try_to_generate_winner should be a tie assuming game.winner works" do
      rank = create(:rank, :level => 1, :exp_required => 0)
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user1.id,
        :round_count => 3, :tie_count => 3)
        #:round_count => 2, :user_1_win_count => 1, :user_2_win_count => 1)
      g1.try_to_generate_winner
      g1.winner.should eq('tie')
      Rank.destroy(rank.id)
    end

    it "try_to_generate_winner should properly update game for tie" do
      rank1 = create(:rank, :level => 1, :exp_required => 0)
      rank2 = create(:rank, :level => 2, :exp_required => 100)
      user1 = create(:user, :level => rank1.level, :exp => rank1.exp_required)
      user2 = create(:user, :level => rank2.level, :exp => rank2.exp_required + 50)
      g1 = build(:game, :user_1_id => user1.id, :user_2_id => user2.id,
        :round_count => 3, :tie_count => 3, :user_1_level => 1, :user_2_level => 2)
      g1.try_to_generate_winner
      g1.reload
      g1.user_1_exp_change.should eq((user2.level - user1.level) * 5)
      g1.user_1_coins_earned.should eq(user1.level * 5)
      g1.user_2_exp_change.should eq((user1.level - user2.level) * 5)
      g1.user_2_coins_earned.should eq(0)
      Rank.destroy(rank1.id)
      Rank.destroy(rank2.id)
      User.destroy(user1.id)
      User.destroy(user2.id)
    end

    it "calculate_challenge_fee should return 0 if fee is less then 0" do
      user1 = create(:user, :level => 3)
      user2 = create(:user, :level => 1)
      g1 = build(:game, :user_1_id => user1.id, :user_2_id => user2.id)
      g1.calculate_challenge_fee.should eq(0)
      User.destroy(user1.id)
      User.destroy(user2.id)
    end

    it "calculate_challenge_fee should return level diff * 10" do
      user1 = create(:user, :level => 1)
      user2 = create(:user, :level => 3)
      g1 = build(:game, :user_1_id => user1.id, :user_2_id => user2.id)
      g1.calculate_challenge_fee.should eq(20)
      User.destroy(user1.id)
      User.destroy(user2.id)
    end
  end
  

  describe "validation" do
    it "player_1_id should not equal player_2_id" do
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => @d_user1.id)
      g1.should_not be_valid
    end

    it "player_1_id and player_2_id should not be nil" do
      g1 = build(:game, :user_1_id => nil, :user_2_id => nil)
      g1.should_not be_valid
    end

    it "player_1_id should not be nil" do
      g1 = build(:game, :user_1_id => @d_user1.id, :user_2_id => nil)
      g1.should_not be_valid
    end

    it "player_2_id should not be nil" do
      g1 = build(:game, :user_1_id => nil, :user_2_id => @d_user2.id)
      g1.should_not be_valid
    end
  end
end
