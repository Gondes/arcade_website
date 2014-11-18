class AddFeeToGamesTable < ActiveRecord::Migration
  def change
  	add_column :games, :fee, :integer, default: 0
  end
end
