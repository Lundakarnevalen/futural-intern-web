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

ActiveRecord::Schema.define(version: 20140323172120) do

  create_table "intressen", force: true do |t|
    t.string "name", null: false
  end

  create_table "intressen_karnevalister", force: true do |t|
    t.integer "intresse_id",    null: false
    t.integer "karnevalist_id", null: false
  end

  add_index "intressen_karnevalister", ["intresse_id"], name: "index_intressen_karnevalister_on_intresse_id", using: :btree
  add_index "intressen_karnevalister", ["karnevalist_id"], name: "index_intressen_karnevalister_on_karnevalist_id", using: :btree

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
    t.text     "google_token"
    t.boolean  "vill_ansvara"
    t.integer  "snalla_intresse"
    t.integer  "snalla_sektion"
    t.text     "ovrigt"
    t.boolean  "medlem_af"
    t.boolean  "medlem_kar"
    t.boolean  "medlem_nation"
    t.boolean  "karneveljsbiljett"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "utcheckad_at"
    t.integer  "avklarat_steg"
    t.string   "foto"
    t.integer  "tilldelad_sektion"
    t.boolean  "tilldelad_klar"
    t.boolean  "pusseldag_keep"
    t.integer  "podio_id"
    t.boolean  "medlem_kollad",         default: false
  end

  add_index "karnevalister", ["efternamn"], name: "index_karnevalister_on_efternamn", using: :btree
  add_index "karnevalister", ["fornamn"], name: "index_karnevalister_on_fornamn", using: :btree
  add_index "karnevalister", ["podio_id"], name: "index_karnevalister_on_podio_id", using: :btree
  add_index "karnevalister", ["snalla_intresse"], name: "index_karnevalister_on_snalla_intresse", using: :btree
  add_index "karnevalister", ["snalla_sektion"], name: "index_karnevalister_on_snalla_sektion", using: :btree

  create_table "karnevalister_sektioner", force: true do |t|
    t.integer "karnevalist_id", null: false
    t.integer "sektion_id",     null: false
  end

  add_index "karnevalister_sektioner", ["karnevalist_id"], name: "index_karnevalister_sektioner_on_karnevalist_id", using: :btree
  add_index "karnevalister_sektioner", ["sektion_id"], name: "index_karnevalister_sektioner_on_sektion_id", using: :btree

  create_table "kon", force: true do |t|
    t.string  "name",     null: false
    t.integer "podio_id"
  end

  add_index "kon", ["podio_id"], name: "index_kon_on_podio_id", using: :btree

  create_table "korkort", force: true do |t|
    t.string  "name",     null: false
    t.integer "podio_id"
  end

  add_index "korkort", ["podio_id"], name: "index_korkort_on_podio_id", using: :btree

  create_table "nationer", force: true do |t|
    t.string  "name",     null: false
    t.integer "podio_id"
  end

  add_index "nationer", ["podio_id"], name: "index_nationer_on_podio_id", using: :btree

  create_table "notifications", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "message"
  end

  create_table "orders", force: true do |t|
    t.string   "status"
    t.datetime "order_date"
    t.datetime "delivery_date"
    t.text     "comment"
    t.integer  "warehouse_code"
    t.integer  "karnevalist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["karnevalist_id"], name: "index_orders_on_karnevalist_id", using: :btree

  create_table "orders_products", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "nbr_of_products"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.text     "google_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podio_syncs", force: true do |t|
    t.datetime "time"
  end

  create_table "product_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "product_type"
    t.integer  "product_category_id"
    t.string   "name"
    t.string   "unit"
    t.string   "ean"
    t.string   "supplier"
    t.text     "info"
    t.string   "stock_location"
    t.text     "notes"
    t.integer  "stock_balance_ordered",     default: 0
    t.integer  "stock_balance_not_ordered", default: 0
    t.integer  "stock_balance_stand_by",    default: 0
    t.float    "purchase_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "warning_limit"
    t.integer  "warehouse_code"
    t.float    "sale_price"
  end

  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "roles_users", force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "sektioner", force: true do |t|
    t.string  "name",     null: false
    t.integer "podio_id"
  end

  add_index "sektioner", ["podio_id"], name: "index_sektioner_on_podio_id", using: :btree

  create_table "storlekar", force: true do |t|
    t.string  "name",     null: false
    t.integer "podio_id"
  end

  add_index "storlekar", ["podio_id"], name: "index_storlekar_on_podio_id", using: :btree

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
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
