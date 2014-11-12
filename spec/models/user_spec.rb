require 'spec_helper'

describe "User" do
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

    pending "Create Test for rank method in #{__FILE__}"
    #it "rank should use level to find rank name" do  
      #user = build(:user)
      #rank = create()
      #user.rank.should eq()
    #end

    it "wins should only change games, wins, and streaks" do
      user = create(:zero_stat_user)
      user.wins
      user.games_played_count.should eq(1)
      user.wins_count.should eq(1)
      user.loss_count.should eq(0)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(1)
      user.current_win_streak.should eq(1)
      User.destroy(user.id)
    end

    it "wins should only change best streak if current streak beats it" do
      user = create(:zero_stat_user, :best_win_streak => 2)
      user.wins
      user.games_played_count.should eq(1)
      user.wins_count.should eq(1)
      user.loss_count.should eq(0)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(2)
      user.current_win_streak.should eq(1)
      User.destroy(user.id)
    end

    it "loses should only change games, loss, and current_streak" do
      user = create(:zero_stat_user, :best_win_streak => 1, :current_win_streak => 1)
      user.loses
      user.games_played_count.should eq(1)
      user.wins_count.should eq(0)
      user.loss_count.should eq(1)
      user.tie_count.should eq(0)
      user.best_win_streak.should eq(1)
      user.current_win_streak.should eq(0)
      User.destroy(user.id)
    end

    it "ties should only change games, and tie" do
      user = create(:zero_stat_user)
      user.ties
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
