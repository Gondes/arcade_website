class AddMoreColumnsToRounds < ActiveRecord::Migration
  def change
  	add_column :rounds, :user_1_win_count, :integer
  	add_column :rounds, :user_2_win_count, :integer
  	add_column :rounds, :tie_count, :integer
  end
end
