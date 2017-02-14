class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.json :contents

      t.timestamps
    end
  end
end
