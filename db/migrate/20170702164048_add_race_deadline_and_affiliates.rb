class AddRaceDeadlineAndAffiliates < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :entry_deadline, :datetime
    create_table :affiliates do |t|
      t.string :name
      t.string :city
    end
    add_reference :users, :affiliates, foreign_key: true
  end
end
