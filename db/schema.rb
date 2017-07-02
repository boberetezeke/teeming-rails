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

ActiveRecord::Schema.define(version: 20170625200914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "candidacy_id"
    t.text    "text"
    t.index ["candidacy_id"], name: "index_answers_on_candidacy_id", using: :btree
    t.index ["question_id"], name: "index_answers_on_question_id", using: :btree
  end

  create_table "candidacies", force: :cascade do |t|
    t.integer "race_id"
    t.integer "user_id"
    t.index ["race_id"], name: "index_candidacies_on_race_id", using: :btree
    t.index ["user_id"], name: "index_candidacies_on_user_id", using: :btree
  end

  create_table "candidate_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "answers_id"
    t.index ["answers_id"], name: "index_candidate_assignments_on_answers_id", using: :btree
    t.index ["role_id"], name: "index_candidate_assignments_on_role_id", using: :btree
    t.index ["user_id"], name: "index_candidate_assignments_on_user_id", using: :btree
  end

  create_table "chapters", force: :cascade do |t|
    t.boolean "is_state_wide"
    t.string  "name"
    t.text    "description"
  end

  create_table "elections", force: :cascade do |t|
    t.integer "chapter_id"
    t.string  "name"
    t.text    "description"
    t.index ["chapter_id"], name: "index_elections_on_chapter_id", using: :btree
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
    t.index ["databank_id"], name: "index_members_on_databank_id", unique: true, using: :btree
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string  "name"
    t.integer "race_id"
    t.index ["race_id"], name: "index_questionnaires_on_race_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.integer "questionnaire_id"
    t.text    "text"
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id", using: :btree
  end

  create_table "races", force: :cascade do |t|
    t.string  "name"
    t.integer "election_id"
    t.integer "role_id"
    t.index ["election_id"], name: "index_races_on_election_id", using: :btree
    t.index ["role_id"], name: "index_races_on_role_id", using: :btree
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "chapter_id"
    t.index ["chapter_id"], name: "index_role_assignments_on_chapter_id", using: :btree
    t.index ["role_id"], name: "index_role_assignments_on_role_id", using: :btree
    t.index ["user_id"], name: "index_role_assignments_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.integer "chapter_id"
    t.string  "name"
    t.text    "description"
    t.index ["chapter_id"], name: "index_roles_on_chapter_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "accepted_bylaws_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "role"
    t.string   "setup_state"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "answers", "candidacies"
  add_foreign_key "answers", "questions"
  add_foreign_key "candidacies", "races"
  add_foreign_key "candidacies", "users"
  add_foreign_key "candidate_assignments", "answers", column: "answers_id"
  add_foreign_key "candidate_assignments", "roles"
  add_foreign_key "candidate_assignments", "users"
  add_foreign_key "elections", "chapters"
  add_foreign_key "questionnaires", "races"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "races", "elections"
  add_foreign_key "races", "roles"
  add_foreign_key "role_assignments", "chapters"
  add_foreign_key "role_assignments", "roles"
  add_foreign_key "role_assignments", "users"
  add_foreign_key "roles", "chapters"
end
