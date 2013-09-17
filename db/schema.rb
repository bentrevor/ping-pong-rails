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

ActiveRecord::Schema.define(version: 20130916211147) do

  create_table "games", force: true do |t|
    t.boolean  "completed",    default: false
    t.integer  "team_1_score", default: 0
    t.integer  "team_2_score", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_id"
  end

  create_table "matches", force: true do |t|
    t.boolean  "completed",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_progress",     default: false
    t.integer  "number_of_games"
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

  create_table "players_teams", force: true do |t|
    t.integer "player_id"
    t.integer "team_id"
  end

  create_table "teams", force: true do |t|
    t.integer "match_id"
  end

end
