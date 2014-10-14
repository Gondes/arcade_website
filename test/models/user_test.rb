require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @user = users(:user_one)
  end

  test "input should pass validations" do
    temp = User.new
    assert_not temp.save, "First/Last/User name should be non nul and less than 25 chars"
  end

  test "name should return username" do
    assert_equal(@user.name, @user.user_name, "name should return the username")
  end

  test "wins should update attributes" do
    assert( @user.increment!(:wins_count), "win_count should increment" )
    assert( @user.increment!(:games_played_count), "games_played_count should increment" )
    assert( @user.increment!(:current_win_streak), "current_win_streak should increment" )
    if (@user.current_win_streak > @user.best_win_streak)
      assert( @user.update_attribute(:best_win_streak, @user.current_win_streak), "should increment best_win_streak" )
    end
  end

  test "loses should update attributes" do
    assert( @user.increment!(:loss_count), "loss_count should increment" )
    assert( @user.increment!(:games_played_count), "games_played_count should increment")
    assert( @user.update_attribute(:current_win_streak, 0), "current_win_streak be set to 0" )
    assert_equal( 0, @user.current_win_streak, "current_win_streak should be set to 0" )
  end

  test "ties should update attributes" do
    assert( @user.increment!(:tie_count), "tie_count should increment" )
    assert( @user.increment!(:games_played_count), "games_played_count should increment" )
  end

  test "reset stats" do
    @user.reset_stats
    assert_equal( 0, @user.wins_count, "wins_count should be set to 0" )
    assert_equal( 0, @user.loss_count, "loss_count should be set to 0" )
    assert_equal( 0, @user.tie_count, "tie_count should be set to 0" )
    assert_equal( 0, @user.current_win_streak, "current_win_streak should be set to 0" )
    assert_equal( 0, @user.best_win_streak, "best_win_streak should be set to 0" )
    assert_equal( 0, @user.games_played_count, "games_played_count should be set to 0" )
  end
end
