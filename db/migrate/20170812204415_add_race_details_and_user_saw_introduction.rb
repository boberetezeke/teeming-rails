class AddRaceDetailsAndUserSawIntroduction < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :saw_introduction, :boolean
    add_column :races, :level_of_government, :string
    add_column :races, :locale, :string
  end
end
