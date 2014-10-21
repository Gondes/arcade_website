class DatabaseMajorRestructuring < ActiveRecord::Migration
  def change
    rename_table :rounds, :rock_paper_scissor_rounds

    add_column :games, :name, :string

    create_table "connect_4_rounds", force: true do |t|
      t.integer  "game_id",      null: false
      t.text     "moves_log"          #This will log the every move that the players make as a string.
                                      #Technically a string should be enough to hold this info but
                                      #We will use a text just in case.
      t.integer  "winner_id"
      t.boolean  "tie"
      t.integer  "round_number"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
