json.array!(@rounds) do |round|
  json.extract! round, :id, :game_id, :user_1_id, :user_1_move, :user_2_id, :user_2_move, :winner_id, :tie
  json.url round_url(round, format: :json)
end
