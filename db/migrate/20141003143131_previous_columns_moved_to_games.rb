class PreviousColumnsMovedToGames < ActiveRecord::Migration
  def change
	remove_column :rounds, :user_1_win_count, :integer
  	remove_column :rounds, :user_2_win_count, :integer
  	remove_column :rounds, :tie_count, :integer

  	add_column :games, :user_1_win_count, :integer
  	add_column :games, :user_2_win_count, :integer
  	add_column :games, :tie_count, :integer
  end
end
