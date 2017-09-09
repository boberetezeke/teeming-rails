class AddRolesAndPrivileges < ActiveRecord::Migration[5.0]
  def up
    drop_table :roles
    drop_table :role_assignments

    create_table :roles do |t|
      t.references  :user, index: true
      t.string      :name
    end

    create_table :privileges do |t|
      t.references    :role, index: true
      t.string        :subject
      t.string        :action
      t.string        :scope
    end
  end

  def down
    drop_table :roles
    drop_table :privileges

    create_table "role_assignments", force: :cascade do |t|
      t.integer "user_id"
      t.integer "role_id"
      t.integer "chapter_id"
    end

    create_table "roles", force: :cascade do |t|
      t.integer "chapter_id"
      t.string  "name"
      t.text    "description"
    end
  end
end
