# encoding: UTF-8

ActiveRecord::Schema.define(version: 20130905185908) do

  create_table "games", force: true do |t|
    t.boolean  "completed",    default: false
    t.integer  "winner",       default: 0
    t.integer  "winner_score", default: 0
    t.integer  "loser_score",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_id"
  end

  create_table "matches", force: true do |t|
    t.boolean  "completed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches_players", force: true do |t|
    t.integer "match_id"
    t.integer "player_id"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
