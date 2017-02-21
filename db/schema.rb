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

ActiveRecord::Schema.define(version: 20170221155202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string   "name"
    t.string   "office"
    t.json     "questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
    t.index ["code"], name: "index_candidates_on_code", unique: true, using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "databank_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "company"
    t.string   "email"
    t.string   "first_name"
    t.string   "home_phone"
    t.string   "last_name"
    t.string   "middle_initial"
    t.string   "mobile_phone"
    t.string   "state"
    t.string   "status"
    t.string   "work_phone"
    t.string   "zip"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "roster_status"
    t.index ["databank_id"], name: "index_members_on_databank_id", unique: true, using: :btree
  end

  create_table "survey_answers", force: :cascade do |t|
    t.json     "contents"
    t.integer  "member_id"
    t.integer  "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id", "survey_id"], name: "index_survey_answers_on_member_id_and_survey_id", unique: true, using: :btree
    t.index ["member_id"], name: "index_survey_answers_on_member_id", using: :btree
    t.index ["survey_id"], name: "index_survey_answers_on_survey_id", using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.json     "contents"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
    t.index ["code"], name: "index_surveys_on_code", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "survey_answers", "members"
  add_foreign_key "survey_answers", "surveys"
end
