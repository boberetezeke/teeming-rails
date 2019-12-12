class AddAccountIdToAllTables < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :account, index: true
    add_reference :candidacies, :account, index: true
    add_reference :chapters, :account, index: true
    add_reference :choices, :account, index: true
    add_reference :choice_tallies, :account, index: true
    add_reference :contact_attempts, :account, index: true
    add_reference :contact_banks, :account, index: true
    add_reference :contactees, :account, index: true
    add_reference :contactors, :account, index: true
    add_reference :elections, :account, index: true
    add_reference :events, :account, index: true
    add_reference :event_rsvps, :account, index: true
    add_reference :event_sign_ins, :account, index: true
    add_reference :issues, :account, index: true
    add_reference :members, :account, index: true
    add_reference :member_groups, :account, index: true
    add_reference :member_group_memberships, :account, index: true
    add_reference :messages, :account, index: true
    add_reference :message_controls, :account, index: true
    add_reference :message_recipients, :account, index: true
    add_reference :notes, :account, index: true
    add_reference :officers, :account, index: true
    add_reference :officer_assignments, :account, index: true
    add_reference :privileges, :account, index: true
    add_reference :questions, :account, index: true
    add_reference :questionnaires, :account, index: true
    add_reference :questionnaire_sections, :account, index: true
    add_reference :races, :account, index: true
    add_reference :roles, :account, index: true
    add_reference :role_assignments, :account, index: true
    add_reference :users, :account, index: true
    add_reference :votes, :account, index: true
    add_reference :vote_completions, :account, index: true
    add_reference :vote_tallies, :account, index: true
  end
end
