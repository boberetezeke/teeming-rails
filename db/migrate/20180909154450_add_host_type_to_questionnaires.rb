class AddHostTypeToQuestionnaires < ActiveRecord::Migration[5.1]
  def change
    add_column :questionnaires, :use_type, :string
  end
end
