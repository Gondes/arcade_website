class SettingDefaultValuesForTables < ActiveRecord::Migration
  def change
	  drop_table :games
	  create_table :games, force: true do |t|
	    t.integer  "user_1_id", :null => false
	    t.integer  "user_2_id", :null => false
	    t.integer  "winner_id"
	    t.boolean  "done" , default: false
	    t.integer  "round_count", default: 0
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "user_1_win_count", default: 0
	    t.integer  "user_2_win_count", default: 0
	    t.integer  "tie_count", default: 0
	  end

	  drop_table :rounds
	  create_table "rounds", force: true do |t|
	    t.integer  "game_id", :null => false
	    t.string   "user_1_move"
	    t.string   "user_2_move"
	    t.integer  "winner_id"
	    t.boolean  "tie"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "round_number"
	  end

	  drop_table :users
	  create_table "users", force: true do |t|
	    t.string   "first_name", :null => false
	    t.string   "last_name", :null => false
	    t.string   "user_name", :null => false
	    t.integer  "games_played_count", default: 0
	    t.integer  "wins_count", default: 0
	    t.integer  "loss_count", default: 0
	    t.integer  "tie_count", default: 0
	    t.integer  "best_win_streak", default: 0
	    t.integer  "current_win_streak", default: 0
	    t.datetime "created_at"
	    t.datetime "updated_at"
	  end
  end
end
