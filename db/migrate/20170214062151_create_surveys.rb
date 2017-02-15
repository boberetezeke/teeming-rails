class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.json :contents
      t.string :name

      t.timestamps
    end

    add_index :surveys, :name, unique: true
  end
end
