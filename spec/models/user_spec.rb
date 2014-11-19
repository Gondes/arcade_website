require 'spec_helper'

describe "User" do
  before(:all) do
    @rankMin = create(:rank, :level => 1, :exp_required => 0, :name => "Dirt")
    @rankMid = create(:rank, :level => 2, :exp_required => 100, :name => "Rock")
    @rankMax = create(:rank, :level => 3, :exp_required => 300, :name => "Iron")
  end

  after(:all) do
    Rank.destroy(@rankMin.id)
    Rank.destroy(@rankMid.id)
    Rank.destroy(@rankMax.id)
  end

  describe "validation" do
    describe "user_name" do
      it "should not be nil" do
        build(:user, :user_name => "").should_not be_valid
      end
      it "max limit should be 24" do
        build(:user, :user_name => "123456789012345678901234").should be_valid
        build(:user, :user_name => "1234567890123456789012345").should_not be_valid
      end
      it "should be unique" do
        user = create(:user, :user_name => "qwert")
        build(:user, :user_name => "qwert").should_not be_valid
        User.destroy(user.id)
      end
      it "should be not be case sensitive" do
        user = create(:user, :user_name => "qwert")
        build(:user, :user_name => "QWERT").should_not be_valid
        User.destroy(user.id)
      end
    end

    describe "first_name" do
      it "should not be nil" do
        build(:user, :first_name => "").should_not be_valid
      end
      it "max limit should be 24" do
        build(:user, :first_name => "123456789012345678901234").should be_valid
        build(:user, :first_name => "1234567890123456789012345").should_not be_valid
      end
    end

    describe "last_name" do
      it "should not be nil" do
        build(:user, :last_name => "").should_not be_valid
      end
      it "max limit should be 24" do
        build(:user, :last_name => "123456789012345678901234").should be_valid
        build(:user, :last_name => "1234567890123456789012345").should_not be_valid
      end
    end
  end

  describe "is_disabled" do
    it "should not be able to log in" do
      user = create(:user, :is_disabled => true)
      user.active_for_authentication?.should eq(false)
      User.destroy(user.id)
    end

    it "should not affect admins" do
      user = create(:user, :is_disabled => true, :admin => true)
      user.active_for_authentication?.should eq(true)
      User.destroy(user.id)
    end
  end

  describe "method" do
    it "name should return user_name" do
      user = create(:user)
      user.name.should eq(user.user_name)
      User.destroy(user.id)
    end

    describe "rank logic:" do
      it "rank should find and return user's rank" do
        user = build(:user, :level => @rankMin.level)
        user.rank.should eq(@rankMin)
      end

      it "show_rank should use level to find rank name" do  
        user = build(:user, :level => @rankMin.level)
        user.show_rank.should eq(user.level.to_s + "-" + @rankMin.name)
      end

      it "next_rank should return next higher rank" do
        user = build(:user, :level => @rankMin.level)
        user.next_rank.should eq(@rankMid)
      end

      it "next_rank should return current rank if user is at max rank" do
        user = build(:user, :level => @rankMax.level)
        user.next_rank.should eq(@rankMax)
      end

      pending "Write test for rare case of double level up for #{__FILE__}"
      # This situation should not occure, unless I add more bonuses to exp gain

      it "previous_rank should return the next lower rank" do
        user = build(:user, :level => @rankMax.level)
        user.previous_rank.should eq(@rankMid)
      end

      it "previous_rank should return current rank if user is at min rank" do
        user = build(:user, :level => @rankMin.level)
        user.previous_rank.should eq(@rankMin)
      end

      it "rank_up should increase the user's level by one" do
        user = create(:user, :level => @rankMin.level)
        user.rank_up
        user.reload
        user.level.should eq(@rankMid.level)
        User.destroy(user.id)
      end

      it "rank_down should decrease the user's level by one" do
        user = create(:user, :level => @rankMax.level)
        user.rank_down
        user.reload
        user.level.should eq(@rankMid.level)
        User.destroy(user.id)
      end

      it "update_rank should correctly rank_up according to exp" do
        user = create(:user, :level => @rankMin.level, :exp => @rankMid.exp_required)
        user.update_rank
        user.reload
        user.level.should eq(@rankMid.level)
        User.destroy(user.id)
      end

      it "update_rank should correctly rank_down according to exp" do
        user = create(:user, :level => @rankMax.level, :exp => @rankMid.exp_required)
        user.update_rank
        user.reload
        user.level.should eq(@rankMid.level)
        User.destroy(user.id)
      end

      it "update_rank should not change level if exp does not exceed level req" do
        user = create(:user, :level => @rankMid.level, :exp => @rankMid.exp_required)
        user.update_rank
        user.reload
        user.level.should eq(@rankMid.level)
        User.destroy(user.id)
      end
    end

    describe "exp logic:" do
      it "calculate_win_exp_against(opponent_level) should return exp = self.level * 10" do
        user = build(:user, :level => @rankMid.level)
        user.calculate_win_exp_against(@rankMid.level)
      end

      it "calculate_win_exp_against(opponent_level) should return x1.5 exp when current_win_streak = 2" do
        user = build(:user, :level => @rankMid.level, :current_win_streak => 2)
        user.calculate_win_exp_against(@rankMid.level)
      end

      it "calculate_win_exp_against(opponent_level) should return x2 exp when current_win_streak > 2" do
        user = build(:user, :level => @rankMid.level, :current_win_streak => 3)
        user.calculate_win_exp_against(@rankMid.level)
      end

      it "calculate_lose_exp_against(opponent_level) should return exp = self.level * 10" do
        user = build(:user, :level => @rankMid.level)
        user.calculate_lose_exp_against(@rankMid.level)
      end

      it "calculate_lose_exp_against(opponent_level) should return at minimum 5" do
        user = build(:user, :level => @rankMin.level)
        user.calculate_lose_exp_against(@rankMax.level)
      end

      it "calculate_tie_exp_against(opponent_level) should return exp = 0" do
        user = build(:user, :level => @rankMid.level, :exp => @rankMid.exp_required)
        user.calculate_tie_exp_against(@rankMid.level)
      end
    end

    it "remove_coins(amount) should reduce current coins" do
      user = build(:user, :coins => 30)
      user.remove_coins(10)
      user.coins.should eq(20)
    end

    it "remove_coins(amount) should not reduce below 0" do
      user = build(:user, :coins => 10)
      user.remove_coins(30)
      user.coins.should eq(0)
    end

    it "add_coins(ammount) should add to current coins" do
      user = build(:user, :coins => 0)
      user.add_coins(10)
      user.coins.should eq(10)
    end

    it "wins_against(opponent_level) testing leveling up" do
      user = build(:user, :level => @rankMid.level, :exp => @rankMax.exp_required - 1)
      user.wins_against(@rankMid.level)
      user.level.should eq(@rankMax.level)
      #just a check to make sure coins is being updated as well
      user.coins.should eq(@rankMid.level * 10)
    end

    it "loses_against(opponent_level) testing leveling down" do
      user = build(:user, :level => @rankMid.level, :exp => @rankMid.exp_required)
      user.loses_against(@rankMid.level)
      user.level.should eq(@rankMin.level)
    end

    it "loses_against(opponent_level) testing mix exp should be 0" do
      user = build(:user, :level => @rankMin.level, :exp => 1)
      user.loses_against(@rankMid.level)
      user.exp.should eq(0)
    end

    it "ties_against(opponent_level) testing" do
      user = build(:user, :level => @rankMid.level, :exp => @rankMid.exp_required)
      user.ties_against(@rankMid.level)
      user.level.should eq(@rankMid.level)
    end

    it "update_stats_wins should only change games, wins, and streaks" do
      user = create(:zero_stat_user)
      user_opponent = build(:user)
      user.update_stats_wins
      user.games_played_count.should eq(1)
      user.wins_count.should eq(1)
      user.loss_count.should eq(0)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(1)
      user.current_win_streak.should eq(1)
      User.destroy(user.id)
    end

    it "update_stats_wins should only change best streak if current streak beats it" do
      user = create(:zero_stat_user, :best_win_streak => 2)
      user_opponent = build(:user)
      user.update_stats_wins
      user.games_played_count.should eq(1)
      user.wins_count.should eq(1)
      user.loss_count.should eq(0)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(2)
      user.current_win_streak.should eq(1)
      User.destroy(user.id)
    end

    it "update_stats_loses should only change games, loss, and current_streak" do
      user = create(:zero_stat_user, :best_win_streak => 1, :current_win_streak => 1)
      user_opponent = build(:user)
      user.update_stats_loses
      user.games_played_count.should eq(1)
      user.wins_count.should eq(0)
      user.loss_count.should eq(1)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(1)
      user.current_win_streak.should eq(0)
      User.destroy(user.id)
    end

    it "update_stats_ties should only change games, and tie" do
      user = create(:zero_stat_user)
      user_opponent = build(:user)
      user.update_stats_ties
      user.games_played_count.should eq(1)
      user.wins_count.should eq(0)
      user.loss_count.should eq(0)
      user.tie_count.should eq(1)
      user.best_win_streak.should eq(0)
      user.current_win_streak.should eq(0)
      User.destroy(user.id)
    end

    it "reset_stats should set all stats to 0" do
      user = create(:sample_stat_user)
      user.reset_stats
      user.games_played_count.should eq(0)
      user.wins_count.should eq(0)
      user.loss_count.should eq(0)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(0)
      user.current_win_streak.should eq(0)
      user.coins.should eq(0)
      user.exp.should eq(0)
      user.level.should eq(1)
      User.destroy(user.id)
    end
  end
end
