require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { best_win_streak: @user.best_win_streak, current_win_streak: @user.current_win_streak, first_name: @user.first_name, games_played_count: @user.games_played_count, last_name: @user.last_name, loss_count: @user.loss_count, tie_count: @user.tie_count, user_name: @user.user_name, wins_count: @user.wins_count }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { best_win_streak: @user.best_win_streak, current_win_streak: @user.current_win_streak, first_name: @user.first_name, games_played_count: @user.games_played_count, last_name: @user.last_name, loss_count: @user.loss_count, tie_count: @user.tie_count, user_name: @user.user_name, wins_count: @user.wins_count }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should reset user stats" do
    put :reset_stats, id: @user, user: { best_win_streak: 0, current_win_streak: 0, first_name: @user.first_name, games_played_count: 0, last_name: @user.last_name, loss_count: 0, tie_count: 0, user_name: @user.user_name, wins_count: 0 }
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
