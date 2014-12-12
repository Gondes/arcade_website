class AddingMoreStatsToGames < ActiveRecord::Migration
  def change
  	add_column :games, :user_1_exp_change, :integer, :default => 0
  	add_column :games, :user_2_exp_change, :integer, :default => 0
  	add_column :games, :user_1_coins_earned, :integer, :default => 0
  	add_column :games, :user_2_coins_earned, :integer, :default => 0
  	add_column :games, :user_1_level, :integer, :default => 0
  	add_column :games, :user_2_level, :integer, :default => 0
  end
end
