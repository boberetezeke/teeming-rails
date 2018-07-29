class AddHideOnDashboard < ActiveRecord::Migration[5.1]
  def change
    remove_column :elections, :hide_on_dashboard, :boolean

    add_column :elections, :visibility, :string
    add_column :events,    :visibility, :string
    add_column :chapters,  :visibility, :string
    add_column :messages,  :visibility, :string
  end
end
