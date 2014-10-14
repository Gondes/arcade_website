require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:game_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, game: { done: @game.done, user_1_id: @game.user_1_id, user_2_id: @game.user_2_id, winner_id: @game.winner_id, round_count: @game.round_count, user_1_win_count: @game.user_1_win_count, user_2_win_count: @game.user_2_win_count, tie_count: @game.tie_count }
    end

    assert_redirected_to game_path(assigns(:game))
  end

  test "should show game" do
    get :show, id: @game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game
    assert_response :success
  end

  test "should update game" do
    patch :update, id: @game, game: { done: @game.done, user_1_id: @game.user_1_id, user_2_id: @game.user_2_id, winner_id: @game.winner_id, round_count: @game.round_count, user_1_win_count: @game.user_1_win_count, user_2_win_count: @game.user_2_win_count, tie_count: @game.tie_count }
    assert_redirected_to game_path(assigns(:game))
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, id: @game
    end

    assert_redirected_to games_path
  end
end
