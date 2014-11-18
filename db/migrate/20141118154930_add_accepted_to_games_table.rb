class AddAcceptedToGamesTable < ActiveRecord::Migration
  def change
  	add_column :games, :accepted, :boolean, default: false
  end
end
