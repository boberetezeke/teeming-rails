class AddSystemSettingsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :system_settings do |t|
      t.boolean :multi_tenant, default: false
      t.datetime :initial_setup_time
      t.integer :setup_status, default: 0
    end
  end
end
