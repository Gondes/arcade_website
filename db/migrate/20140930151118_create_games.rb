class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_1_id
      t.integer :user_2_id
      t.integer :winner_id
      t.boolean :done
      t.string :type

      t.timestamps
    end
  end
end
