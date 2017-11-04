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

ActiveRecord::Schema.define(version: 20171101045012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string  "name"
    t.boolean "registration_disabled"
    t.string  "registration_disabled_reason"
  end

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "candidacy_id"
    t.text    "text"
    t.integer "order_index"
    t.integer "user_id"
    t.string  "answerable_type"
    t.integer "answerable_id"
    t.index ["answerable_id"], name: "index_answers_on_answerable_id", using: :btree
    t.index ["user_id"], name: "index_answers_on_user_id", using: :btree
  end

  create_table "candidacies", force: :cascade do |t|
    t.integer  "race_id"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "party_affiliation"
    t.text     "notes"
    t.index ["created_by_user_id"], name: "index_candidacies_on_created_by_user_id", using: :btree
    t.index ["updated_by_user_id"], name: "index_candidacies_on_updated_by_user_id", using: :btree
  end

  create_table "candidate_assignments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "answers_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.boolean "is_state_wide"
    t.string  "name"
    t.text    "description"
  end

  create_table "choices", force: :cascade do |t|
    t.integer "question_id"
    t.integer "order_index"
    t.string  "title"
    t.string  "value"
    t.index ["question_id"], name: "index_choices_on_question_id", using: :btree
  end

  create_table "elections", force: :cascade do |t|
    t.integer  "chapter_id"
    t.string   "name"
    t.text     "description"
    t.date     "vote_date"
    t.string   "election_type"
    t.boolean  "hide_on_dashboard"
    t.integer  "member_group_id"
    t.datetime "vote_start_time"
    t.datetime "vote_end_time"
    t.boolean  "show_vote_tallies"
    t.boolean  "is_frozen"
    t.index ["member_group_id"], name: "index_elections_on_member_group_id", using: :btree
  end

  create_table "event_rsvps", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.string  "rsvp_type"
    t.index ["event_id"], name: "index_event_rsvps_on_event_id", using: :btree
    t.index ["user_id"], name: "index_event_rsvps_on_user_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "occurs_at"
    t.string   "location"
    t.float    "longitude"
    t.float    "latitude"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "election_id"
    t.string  "name"
    t.integer "created_by_user_id"
    t.integer "updated_by_user_id"
    t.index ["created_by_user_id"], name: "index_issues_on_created_by_user_id", using: :btree
    t.index ["election_id"], name: "index_issues_on_election_id", using: :btree
    t.index ["updated_by_user_id"], name: "index_issues_on_updated_by_user_id", using: :btree
  end

  create_table "member_group_memberships", force: :cascade do |t|
    t.integer "member_id"
    t.integer "member_group_id"
    t.index ["member_group_id"], name: "index_member_group_memberships_on_member_group_id", using: :btree
    t.index ["member_id"], name: "index_member_group_memberships_on_member_id", using: :btree
  end

  create_table "member_groups", force: :cascade do |t|
    t.string "name"
    t.string "group_type"
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
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "chapter_id"
    t.boolean  "interested_in_starting_chapter"
    t.integer  "potential_chapter_id"
    t.index ["chapter_id"], name: "index_members_on_chapter_id", using: :btree
    t.index ["databank_id"], name: "index_members_on_databank_id", unique: true, using: :btree
    t.index ["potential_chapter_id"], name: "index_members_on_potential_chapter_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "message_controls", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "unsubscribed_from_message_id_id"
    t.datetime "unsubscribed_at"
    t.string   "unsubscribe_reason"
    t.index ["member_id"], name: "index_message_controls_on_member_id", using: :btree
    t.index ["unsubscribed_from_message_id_id"], name: "index_message_controls_on_unsubscribed_from_message_id_id", using: :btree
  end

  create_table "message_recipients", force: :cascade do |t|
    t.integer "message_id"
    t.integer "member_id"
    t.index ["member_id"], name: "index_message_recipients_on_member_id", using: :btree
    t.index ["message_id"], name: "index_message_recipients_on_message_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.string  "subject"
    t.string  "body"
    t.string  "to"
    t.string  "message_type"
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "privileges", force: :cascade do |t|
    t.integer "role_id"
    t.string  "subject"
    t.string  "action"
    t.string  "scope"
    t.index ["role_id"], name: "index_privileges_on_role_id", using: :btree
  end

  create_table "questionnaire_sections", force: :cascade do |t|
    t.integer "questionnaire_id"
    t.string  "title"
    t.integer "order_index"
    t.index ["questionnaire_id"], name: "index_questionnaire_sections_on_questionnaire_id", using: :btree
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string  "name"
    t.integer "race_id"
    t.string  "questionnairable_type"
    t.integer "questionnairable_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "questionnaire_id"
    t.text    "text"
    t.string  "question_type"
    t.integer "order_index"
    t.integer "questionnaire_section_id"
    t.index ["questionnaire_section_id"], name: "index_questions_on_questionnaire_section_id", using: :btree
  end

  create_table "races", force: :cascade do |t|
    t.string   "name"
    t.integer  "election_id"
    t.integer  "role_id"
    t.datetime "filing_deadline_date"
    t.date     "candidates_announcement_date"
    t.string   "level_of_government"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.text     "notes"
    t.datetime "vote_start_time"
    t.datetime "vote_end_time"
    t.boolean  "show_vote_tallies"
    t.index ["created_by_user_id"], name: "index_races_on_created_by_user_id", using: :btree
    t.index ["updated_by_user_id"], name: "index_races_on_updated_by_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "accepted_bylaws_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "setup_state"
    t.boolean  "run_for_state_board"
    t.boolean  "interested_in_volunteering"
    t.boolean  "saw_introduction"
    t.integer  "role_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "vote_completions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "race_id"
    t.boolean "has_voted"
    t.string  "token"
    t.string  "vote_type"
    t.string  "disqualification_message"
    t.integer "election_id"
    t.index ["election_id"], name: "index_vote_completions_on_election_id", using: :btree
    t.index ["race_id"], name: "index_vote_completions_on_race_id", using: :btree
    t.index ["token"], name: "index_vote_completions_on_token", using: :btree
    t.index ["user_id"], name: "index_vote_completions_on_user_id", using: :btree
  end

  create_table "vote_tallies", force: :cascade do |t|
    t.integer "race_id"
    t.integer "candidacy_id"
    t.integer "vote_count"
    t.index ["candidacy_id"], name: "index_vote_tallies_on_candidacy_id", using: :btree
    t.index ["race_id"], name: "index_vote_tallies_on_race_id", using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "candidacy_id"
    t.integer "race_id"
    t.index ["candidacy_id"], name: "index_votes_on_candidacy_id", using: :btree
    t.index ["race_id"], name: "index_votes_on_race_id", using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
  end

end
