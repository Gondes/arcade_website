class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :user_1_id
      t.string :user_1_move
      t.integer :user_2_id
      t.string :user_2_move
      t.integer :winner_id
      t.boolean :tie

      t.timestamps
    end
  end
end
