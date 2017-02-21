class AddCodeToSurveysAndCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :code, :string
    add_column :candidates, :code, :string

    remove_index :surveys, :name
    remove_index :candidates, :name

    add_index :surveys, :code, unique: true
    add_index :candidates, :code, unique: true
  end
end
