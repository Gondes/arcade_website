require 'test_helper'

class RoundsControllerTest < ActionController::TestCase
  setup do
    @round = rounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create round" do
    assert_difference('Round.count') do
      post :create, round: { game_id: @round.game_id, tie: @round.tie, user_1_id: @round.user_1_id, user_1_move: @round.user_1_move, user_2_id: @round.user_2_id, user_2_move: @round.user_2_move, winner_id: @round.winner_id }
    end

    assert_redirected_to round_path(assigns(:round))
  end

  test "should show round" do
    get :show, id: @round
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @round
    assert_response :success
  end

  test "should update round" do
    patch :update, id: @round, round: { game_id: @round.game_id, tie: @round.tie, user_1_id: @round.user_1_id, user_1_move: @round.user_1_move, user_2_id: @round.user_2_id, user_2_move: @round.user_2_move, winner_id: @round.winner_id }
    assert_redirected_to round_path(assigns(:round))
  end

  test "should destroy round" do
    assert_difference('Round.count', -1) do
      delete :destroy, id: @round
    end

    assert_redirected_to rounds_path
  end
end
