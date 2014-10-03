# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141003143131) do

  create_table "games", force: true do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.integer  "winner_id"
    t.boolean  "done"
    t.integer  "game_to",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_1_win_count"
    t.integer  "user_2_win_count"
    t.integer  "tie_count"
  end

  create_table "rounds", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_1_id"
    t.string   "user_1_move"
    t.integer  "user_2_id"
    t.string   "user_2_move"
    t.integer  "winner_id"
    t.boolean  "tie"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_number"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.integer  "games_played_count"
    t.integer  "wins_count"
    t.integer  "loss_count"
    t.integer  "tie_count"
    t.integer  "best_win_streak"
    t.integer  "current_win_streak"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
