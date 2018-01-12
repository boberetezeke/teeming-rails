class AddVisibilityTables < ActiveRecord::Migration[5.0]
  def change
    create_table :role_assignments do |t|
      t.references  :role, index: true
      t.references  :user, index: true
    end

    create_table :offices_assignments do |t|
      t.references  :officer, index: true
      t.references  :user, index: true
      t.references  :chapter, index: true
    end

    create_table :offices do |t|
      t.string :name
      t.date   :start_date
    end

    create_table :shares do |t|
      t.string :subject
      t.string :scope
    end

    add_column :users, :username, :string

  end
end
