class AddPolyToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :answerable_type, :string
    add_column :answers, :answerable_id, :integer
    add_index :answers, :answerable_id
  end
end
