class CreatingRankTableAndAddingParamsToUser < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer  "level"
      t.string   "name"
      t.integer  "exp_required"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_column :users, :coins, :integer, default: 0
    add_column :users, :exp, :integer, default: 0
    add_column :users, :level, :integer, default: 1
  end
end
