class CreateCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :office
      t.json :questions

      t.timestamps
    end

    add_index :candidates, :name, unique: true
  end
end
