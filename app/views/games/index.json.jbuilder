json.array!(@games) do |game|
  json.extract! game, :id, :user_1_id, :user_2_id, :winner_id, :done, :round_count, :user_1_win_count, :user_2_win_count, :tie_count
  json.url game_url(game, format: :json)
end
