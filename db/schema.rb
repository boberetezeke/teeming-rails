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

ActiveRecord::Schema.define(version: 20170214150253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "members" because of following StandardError
#   Unknown type 'member_status' for column 'status'

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
