class ChangeTypeOfGameToColumn < ActiveRecord::Migration
  def change
  	change_column :games, :game_to, :integer
  end
end
