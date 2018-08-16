class AddTimestamps < ActiveRecord::Migration[5.1]
  def change
    add_column :elections, :created_at, :datetime
    add_column :elections, :updated_at, :datetime
    add_column :events, :created_at, :datetime
    add_column :events, :updated_at, :datetime
    add_column :issues, :created_at, :datetime
    add_column :issues, :updated_at, :datetime
    add_column :message_controls, :created_at, :datetime
    add_column :message_controls, :updated_at, :datetime
    add_column :officers, :created_at, :datetime
    add_column :officers, :updated_at, :datetime
    add_column :roles, :created_at, :datetime
    add_column :roles, :updated_at, :datetime
    add_column :vote_completions, :created_at, :datetime
    add_column :vote_completions, :updated_at, :datetime
  end
end
