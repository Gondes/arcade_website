json.array!(@games) do |game|
  json.extract! game, :id, :user_1_id, :user_2_id, :winner_id, :done, :game_to
  json.url game_url(game, format: :json)
end
