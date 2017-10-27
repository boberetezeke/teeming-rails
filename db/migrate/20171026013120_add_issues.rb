class AddIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.references :election, index: true
      t.string :name
      t.integer :created_by_user_id
      t.integer :updated_by_user_id
    end

    add_index :issues, :created_by_user_id
    add_index :issues, :updated_by_user_id
  end
end
