json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :user_name, :games_played_count, :wins_count, :loss_count, :tie_count, :best_win_streak, :current_win_streak
  json.url user_url(user, format: :json)
end
