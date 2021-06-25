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

ActiveRecord::Schema.define(version: 2021_05_07_040127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "registration_disabled"
    t.string "registration_disabled_reason"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "question_id"
    t.integer "candidacy_id"
    t.text "text"
    t.integer "order_index"
    t.integer "user_id"
    t.string "answerable_type"
    t.integer "answerable_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_answers_on_account_id"
    t.index ["answerable_id"], name: "index_answers_on_answerable_id"
    t.index ["candidacy_id"], name: "index_answers_on_candidacy_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "candidacies", id: :serial, force: :cascade do |t|
    t.integer "race_id"
    t.integer "user_id"
    t.string "name"
    t.integer "created_by_user_id"
    t.integer "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "party_affiliation"
    t.text "notes"
    t.string "email"
    t.string "token"
    t.datetime "questionnaire_submitted_at"
    t.datetime "unlock_requested_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_candidacies_on_account_id"
    t.index ["created_by_user_id"], name: "index_candidacies_on_created_by_user_id"
    t.index ["race_id"], name: "index_candidacies_on_race_id"
    t.index ["updated_by_user_id"], name: "index_candidacies_on_updated_by_user_id"
    t.index ["user_id"], name: "index_candidacies_on_user_id"
  end

  create_table "candidate_assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "answers_id"
    t.index ["answers_id"], name: "index_candidate_assignments_on_answers_id"
    t.index ["role_id"], name: "index_candidate_assignments_on_role_id"
    t.index ["user_id"], name: "index_candidate_assignments_on_user_id"
  end

  create_table "chapters", id: :serial, force: :cascade do |t|
    t.boolean "is_state_wide"
    t.string "name"
    t.text "description"
    t.string "visibility"
    t.string "chapter_type"
    t.text "boundaries_description_yml"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_chapters_on_account_id"
  end

  create_table "choice_tallies", id: :serial, force: :cascade do |t|
    t.integer "question_id"
    t.string "value"
    t.integer "count"
    t.integer "round"
    t.integer "questionnaire_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_choice_tallies_on_account_id"
    t.index ["question_id"], name: "index_choice_tallies_on_question_id"
    t.index ["questionnaire_id"], name: "index_choice_tallies_on_questionnaire_id"
  end

  create_table "choice_tally_answers", id: :serial, force: :cascade do |t|
    t.integer "choice_tally_id"
    t.integer "answer_id"
    t.index ["answer_id"], name: "index_choice_tally_answers_on_answer_id"
    t.index ["choice_tally_id"], name: "index_choice_tally_answers_on_choice_tally_id"
  end

  create_table "choices", id: :serial, force: :cascade do |t|
    t.integer "question_id"
    t.integer "order_index"
    t.string "title"
    t.string "value"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_choices_on_account_id"
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "contact_attempts", force: :cascade do |t|
    t.bigint "contactor_id"
    t.bigint "contactee_id"
    t.string "contact_type"
    t.string "direction_type"
    t.string "result_type"
    t.text "notes"
    t.datetime "attempted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_contact_attempts_on_account_id"
    t.index ["contactee_id"], name: "index_contact_attempts_on_contactee_id"
    t.index ["contactor_id"], name: "index_contact_attempts_on_contactor_id"
  end

  create_table "contact_banks", force: :cascade do |t|
    t.string "name"
    t.text "script"
    t.text "notes"
    t.bigint "owner_id"
    t.bigint "member_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.text "email_script"
    t.text "sms_script"
    t.index ["account_id"], name: "index_contact_banks_on_account_id"
    t.index ["member_group_id"], name: "index_contact_banks_on_member_group_id"
    t.index ["owner_id"], name: "index_contact_banks_on_owner_id"
  end

  create_table "contactees", force: :cascade do |t|
    t.bigint "contact_bank_id"
    t.bigint "member_id"
    t.datetime "contact_started_at"
    t.datetime "contact_completed_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_contactees_on_account_id"
    t.index ["contact_bank_id"], name: "index_contactees_on_contact_bank_id"
    t.index ["member_id"], name: "index_contactees_on_member_id"
  end

  create_table "contactors", force: :cascade do |t|
    t.bigint "contact_bank_id"
    t.bigint "user_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_contactors_on_account_id"
    t.index ["contact_bank_id"], name: "index_contactors_on_contact_bank_id"
    t.index ["user_id"], name: "index_contactors_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "elections", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "vote_date"
    t.string "election_type"
    t.integer "member_group_id"
    t.datetime "vote_start_time"
    t.datetime "vote_end_time"
    t.boolean "show_vote_tallies"
    t.boolean "is_frozen"
    t.string "election_method"
    t.boolean "is_public"
    t.string "visibility"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_elections_on_account_id"
    t.index ["member_group_id"], name: "index_elections_on_member_group_id"
  end

  create_table "event_rsvps", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.string "rsvp_type"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_event_rsvps_on_account_id"
    t.index ["event_id"], name: "index_event_rsvps_on_event_id"
    t.index ["user_id"], name: "index_event_rsvps_on_user_id"
  end

  create_table "event_sign_ins", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "memeber_id"
    t.string "sign_in_type"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_event_sign_ins_on_account_id"
    t.index ["event_id"], name: "index_event_sign_ins_on_event_id"
    t.index ["memeber_id"], name: "index_event_sign_ins_on_memeber_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "occurs_at"
    t.string "location"
    t.float "longitude"
    t.float "latitude"
    t.integer "member_group_id"
    t.datetime "published_at"
    t.text "agenda"
    t.string "visibility"
    t.string "event_type"
    t.text "online_details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_events_on_account_id"
    t.index ["member_group_id"], name: "index_events_on_member_group_id"
  end

  create_table "importers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "filename"
    t.string "original_filename"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_importers_on_user_id"
  end

  create_table "issues", id: :serial, force: :cascade do |t|
    t.integer "election_id"
    t.string "name"
    t.integer "created_by_user_id"
    t.integer "updated_by_user_id"
    t.integer "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_issues_on_account_id"
    t.index ["chapter_id"], name: "index_issues_on_chapter_id"
    t.index ["created_by_user_id"], name: "index_issues_on_created_by_user_id"
    t.index ["election_id"], name: "index_issues_on_election_id"
    t.index ["updated_by_user_id"], name: "index_issues_on_updated_by_user_id"
  end

  create_table "member_group_memberships", id: :serial, force: :cascade do |t|
    t.integer "member_id"
    t.integer "member_group_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_member_group_memberships_on_account_id"
    t.index ["member_group_id"], name: "index_member_group_memberships_on_member_group_id"
    t.index ["member_id"], name: "index_member_group_memberships_on_member_id"
  end

  create_table "member_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "group_type"
    t.string "scope_type"
    t.bigint "account_id"
    t.integer "organization_id"
    t.string "type", default: "MemberGroup"
    t.boolean "is_state_wide"
    t.string "description"
    t.string "visibility"
    t.string "chapter_type"
    t.text "boundaries_description_yml"
    t.index ["account_id"], name: "index_member_groups_on_account_id"
    t.index ["organization_id"], name: "index_member_groups_on_organization_id"
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.integer "databank_id"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "company"
    t.string "email"
    t.string "first_name"
    t.string "home_phone"
    t.string "last_name"
    t.string "middle_initial"
    t.string "mobile_phone"
    t.string "state"
    t.string "status"
    t.string "work_phone"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "chapter_id"
    t.boolean "interested_in_starting_chapter"
    t.integer "potential_chapter_id"
    t.text "bio"
    t.boolean "added_with_new_user"
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_non_member"
    t.text "notes"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_members_on_account_id"
    t.index ["chapter_id"], name: "index_members_on_chapter_id"
    t.index ["databank_id"], name: "index_members_on_databank_id", unique: true
    t.index ["latitude", "longitude"], name: "index_members_on_latitude_and_longitude"
    t.index ["potential_chapter_id"], name: "index_members_on_potential_chapter_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "message_controls", id: :serial, force: :cascade do |t|
    t.integer "member_id"
    t.datetime "unsubscribed_at"
    t.string "unsubscribe_reason"
    t.integer "unsubscribed_from_message_id"
    t.string "unsubscribe_type"
    t.string "control_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_message_controls_on_account_id"
    t.index ["member_id"], name: "index_message_controls_on_member_id"
    t.index ["unsubscribed_from_message_id"], name: "index_message_controls_on_unsubscribed_from_message_id"
  end

  create_table "message_recipients", id: :serial, force: :cascade do |t|
    t.integer "message_id"
    t.integer "member_id"
    t.integer "candidacy_id"
    t.string "token"
    t.string "email"
    t.datetime "queued_at"
    t.datetime "sent_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_message_recipients_on_account_id"
    t.index ["candidacy_id"], name: "index_message_recipients_on_candidacy_id"
    t.index ["member_id"], name: "index_message_recipients_on_member_id"
    t.index ["message_id"], name: "index_message_recipients_on_message_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "subject"
    t.string "body"
    t.string "to"
    t.string "message_type"
    t.integer "member_group_id"
    t.integer "election_id"
    t.integer "race_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.integer "event_id"
    t.string "visibility"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_messages_on_account_id"
    t.index ["election_id"], name: "index_messages_on_election_id"
    t.index ["event_id"], name: "index_messages_on_event_id"
    t.index ["member_group_id"], name: "index_messages_on_member_group_id"
    t.index ["race_id"], name: "index_messages_on_race_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.bigint "user_id"
    t.bigint "member_group_id"
    t.string "title"
    t.text "body"
    t.datetime "published_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_notes_on_account_id"
    t.index ["member_group_id"], name: "index_notes_on_member_group_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "officer_assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "officer_id"
    t.date "start_date"
    t.date "end_date"
    t.string "reason_for_start"
    t.string "reason_for_end"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_officer_assignments_on_account_id"
    t.index ["officer_id"], name: "index_officer_assignments_on_officer_id"
    t.index ["user_id"], name: "index_officer_assignments_on_user_id"
  end

  create_table "officers", id: :serial, force: :cascade do |t|
    t.string "officer_type"
    t.date "start_date"
    t.date "end_date"
    t.integer "member_id"
    t.integer "member_group_id"
    t.text "responsibilities"
    t.boolean "is_board_member"
    t.boolean "is_executive_committee_member"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_officers_on_account_id"
    t.index ["member_group_id"], name: "index_officers_on_member_group_id"
    t.index ["member_id"], name: "index_officers_on_member_id"
  end

  create_table "privileges", id: :serial, force: :cascade do |t|
    t.integer "role_id"
    t.string "subject"
    t.string "action"
    t.string "scope"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_privileges_on_account_id"
    t.index ["role_id"], name: "index_privileges_on_role_id"
  end

  create_table "questionnaire_sections", id: :serial, force: :cascade do |t|
    t.integer "questionnaire_id"
    t.string "title"
    t.integer "order_index"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_questionnaire_sections_on_account_id"
    t.index ["questionnaire_id"], name: "index_questionnaire_sections_on_questionnaire_id"
  end

  create_table "questionnaires", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "race_id"
    t.string "questionnairable_type"
    t.integer "questionnairable_id"
    t.string "use_type"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_questionnaires_on_account_id"
    t.index ["race_id"], name: "index_questionnaires_on_race_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "questionnaire_id"
    t.text "text"
    t.string "question_type"
    t.integer "order_index"
    t.integer "questionnaire_section_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_questions_on_account_id"
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
    t.index ["questionnaire_section_id"], name: "index_questions_on_questionnaire_section_id"
  end

  create_table "races", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "election_id"
    t.integer "role_id"
    t.datetime "filing_deadline_date"
    t.date "candidates_announcement_date"
    t.string "level_of_government"
    t.string "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "created_by_user_id"
    t.integer "updated_by_user_id"
    t.text "notes"
    t.datetime "vote_start_time"
    t.datetime "vote_end_time"
    t.boolean "show_vote_tallies"
    t.integer "chapter_id"
    t.boolean "is_official"
    t.boolean "endorsement_complete"
    t.integer "election_candidacy_segregation_choice_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_races_on_account_id"
    t.index ["chapter_id"], name: "index_races_on_chapter_id"
    t.index ["created_by_user_id"], name: "index_races_on_created_by_user_id"
    t.index ["election_id"], name: "index_races_on_election_id"
    t.index ["role_id"], name: "index_races_on_role_id"
    t.index ["updated_by_user_id"], name: "index_races_on_updated_by_user_id"
  end

  create_table "role_assignments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "officer_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_role_assignments_on_account_id"
    t.index ["officer_id"], name: "index_role_assignments_on_officer_id"
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
    t.index ["user_id"], name: "index_role_assignments_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "combined"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_roles_on_account_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_account_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "account_id"
    t.string "role"
    t.index ["account_id"], name: "index_user_account_memberships_on_account_id"
    t.index ["user_id"], name: "index_user_account_memberships_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "accepted_bylaws_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "setup_state"
    t.boolean "run_for_state_board"
    t.boolean "interested_in_volunteering"
    t.boolean "saw_introduction"
    t.integer "role_id"
    t.boolean "share_email"
    t.boolean "share_address"
    t.boolean "share_phone"
    t.boolean "share_name"
    t.boolean "use_username"
    t.string "fixed_role"
    t.bigint "account_id"
    t.integer "selected_account_id"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["selected_account_id"], name: "index_users_on_selected_account_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vote_completions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "race_id"
    t.boolean "has_voted"
    t.string "token"
    t.string "vote_type"
    t.string "disqualification_message"
    t.integer "election_id"
    t.string "ballot_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_vote_completions_on_account_id"
    t.index ["election_id"], name: "index_vote_completions_on_election_id"
    t.index ["race_id"], name: "index_vote_completions_on_race_id"
    t.index ["token"], name: "index_vote_completions_on_token"
    t.index ["user_id"], name: "index_vote_completions_on_user_id"
  end

  create_table "vote_tallies", id: :serial, force: :cascade do |t|
    t.integer "race_id"
    t.integer "candidacy_id"
    t.integer "vote_count"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_vote_tallies_on_account_id"
    t.index ["candidacy_id"], name: "index_vote_tallies_on_candidacy_id"
    t.index ["race_id"], name: "index_vote_tallies_on_race_id"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "candidacy_id"
    t.integer "race_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_votes_on_account_id"
    t.index ["candidacy_id"], name: "index_votes_on_candidacy_id"
    t.index ["race_id"], name: "index_votes_on_race_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "candidacies"
  add_foreign_key "answers", "questions"
  add_foreign_key "candidacies", "races"
  add_foreign_key "candidacies", "users"
  add_foreign_key "candidate_assignments", "answers", column: "answers_id"
  add_foreign_key "candidate_assignments", "users"
  add_foreign_key "questionnaires", "races"
  add_foreign_key "questions", "questionnaires"
  add_foreign_key "races", "elections"
end
