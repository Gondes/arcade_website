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

ActiveRecord::Schema.define(version: 20141112145415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "user_1_id",                        null: false
    t.integer  "user_2_id",                        null: false
    t.integer  "winner_id"
    t.boolean  "done",             default: false
    t.integer  "round_count",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_1_win_count", default: 0
    t.integer  "user_2_win_count", default: 0
    t.integer  "tie_count",        default: 0
    t.string   "name"
  end

  create_table "ranks", force: true do |t|
    t.integer  "level"
    t.string   "name"
    t.integer  "exp_required"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rock_paper_scissor_rounds", force: true do |t|
    t.integer  "game_id",      null: false
    t.string   "user_1_move"
    t.string   "user_2_move"
    t.integer  "winner_id"
    t.boolean  "tie"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_number"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",                             null: false
    t.string   "last_name",                              null: false
    t.string   "user_name",                              null: false
    t.integer  "games_played_count",     default: 0
    t.integer  "wins_count",             default: 0
    t.integer  "loss_count",             default: 0
    t.integer  "tie_count",              default: 0
    t.integer  "best_win_streak",        default: 0
    t.integer  "current_win_streak",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean  "admin",                  default: false
    t.boolean  "is_disabled",            default: false
    t.boolean  "is_hidden",              default: false
    t.integer  "coins",                  default: 0
    t.integer  "exp",                    default: 0
    t.integer  "level",                  default: 1
  end

end
