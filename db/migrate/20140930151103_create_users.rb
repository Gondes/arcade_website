class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.integer :games_played_count
      t.integer :wins_count
      t.integer :loss_count
      t.integer :tie_count
      t.integer :best_win_streak
      t.integer :current_win_streak

      t.timestamps
    end
  end
end
