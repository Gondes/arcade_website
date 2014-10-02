class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :games, :type, :game_to
  end
end
