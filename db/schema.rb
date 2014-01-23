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

ActiveRecord::Schema.define(version: 20140122220708) do

  create_table "intressen", force: true do |t|
    t.string "name", null: false
  end

  create_table "intressen_karnevalister", force: true do |t|
    t.integer "intresse_id",    null: false
    t.integer "karnevalist_id", null: false
  end

  create_table "karnevalister", force: true do |t|
    t.string   "personnummer"
    t.integer  "kon_id"
    t.string   "fornamn"
    t.string   "efternamn"
    t.string   "gatuadress"
    t.string   "postnr"
    t.string   "postort"
    t.string   "email"
    t.string   "telnr"
    t.integer  "nation_id"
    t.string   "matpref"
    t.integer  "storlek_id"
    t.integer  "terminer"
    t.integer  "korkort_id"
    t.string   "engagerad_kar"
    t.string   "engagerad_nation"
    t.string   "engagerad_studentikos"
    t.string   "engagerad_etc"
    t.boolean  "jobbat_heltid"
    t.boolean  "jobbat_styrelse"
    t.boolean  "jobbat_forman"
    t.boolean  "jobbat_aktiv"
    t.boolean  "karnevalist_2010"
    t.string   "google_token"
    t.boolean  "vill_ansvara"
    t.integer  "snalla_intresse"
    t.integer  "snalla_sektion"
    t.text     "ovrigt"
    t.string   "foto"
    t.boolean  "medlem_af"
    t.boolean  "medlem_kar"
    t.boolean  "medlem_nation"
    t.boolean  "karneveljsbiljett"
    t.boolean  "utcheckad"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "karnevalister_sektioner", force: true do |t|
    t.integer "karnevalist_id", null: false
    t.integer "sektion_id",     null: false
  end

  create_table "kon", force: true do |t|
    t.string "name", null: false
  end

  create_table "korkort", force: true do |t|
    t.string "name", null: false
  end

  create_table "nationer", force: true do |t|
    t.string "name", null: false
  end

  create_table "sektioner", force: true do |t|
    t.string "name", null: false
  end

  create_table "storlekar", force: true do |t|
    t.string "name", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
end
