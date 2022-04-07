class AddWhenToMeets < ActiveRecord::Migration[5.2]
  def change
    create_table :when_to_meets do |t|
      t.string :name
      t.text :users
      t.date :start_date
      t.date :end_date
      t.integer :starting_hour
      t.integer :ending_hour
      t.text :time_slots
    end
  end
end
